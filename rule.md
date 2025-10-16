# Quy tắc Clean Architecture cho Flutter Base

## Tổng quan

Dự án này sử dụng **Clean Architecture** kết hợp với **BLoC Pattern** và **Dependency Injection (Injectable)**. Mọi tính năng mới phải tuân thủ các quy tắc sau.

---

## Cấu trúc thư mục bắt buộc

Mỗi feature phải có cấu trúc 3 layers sau:

```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   │   └── {feature}_remote_data_source.dart
│   ├── models/
│   │   └── {model}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {entity}.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── {action}_{feature}.dart
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_event.dart
    │   ├── {feature}_state.dart
    │   └── bloc.dart (export file)
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        └── {widget}_widget.dart (nếu cần)
```

---

## Luồng đi của dữ liệu (Data Flow)

```
UI (Widget)
    ↓ dispatches event
BLoC (Business Logic)
    ↓ calls
UseCase (Domain Logic)
    ↓ calls
Repository Interface (Domain)
    ↑ implements
Repository Implementation (Data)
    ↓ calls
DataSource (Remote/Local)
    ↓ calls
API/Database
    ↑ returns raw data
DataSource
    ↑ returns Model
Repository Implementation
    ↑ converts Model to Entity
    ↑ returns Either<Failure, Entity>
UseCase
    ↑ returns Either<Failure, Entity>
BLoC
    ↓ emits new State
UI updates
```

---

## Quy tắc bắt buộc khi thêm tính năng mới

### 1. Domain Layer (Business Logic - Core)

#### 1.1. Entity
- **Vị trí**: `lib/features/{feature}/domain/entities/{entity}.dart`
- **Quy tắc**:
  - Chỉ chứa thuộc tính và business logic
  - KHÔNG phụ thuộc vào framework
  - Kế thừa `Equatable` để so sánh
  - KHÔNG chứa JSON serialization

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}
```

#### 1.2. Repository Interface
- **Vị trí**: `lib/features/{feature}/domain/repositories/{feature}_repository.dart`
- **Quy tắc**:
  - Chỉ định nghĩa interface (abstract class)
  - Return type phải là `Either<Failure, T>`
  - KHÔNG chứa implementation

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserById(String id);
  Future<Either<Failure, List<User>>> getAllUsers();
}
```

#### 1.3. UseCase
- **Vị trí**: `lib/features/{feature}/domain/usecases/{action}_{feature}.dart`
- **Quy tắc**:
  - Mỗi UseCase chỉ làm MỘT việc
  - Kế thừa `UseCase<Type, Params>`
  - Dùng `@lazySingleton` hoặc `@injectable`
  - Nếu không có params, dùng `NoParams`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserById implements UseCase<User, String> {
  final UserRepository repository;

  GetUserById(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUserById(userId);
  }
}
```

---

### 2. Data Layer (Implementation)

#### 2.1. Model
- **Vị trí**: `lib/features/{feature}/data/models/{model}_model.dart`
- **Quy tắc**:
  - Kế thừa Entity tương ứng
  - Có `fromJson` và `toJson`
  - KHÔNG chứa business logic

```dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

#### 2.2. DataSource
- **Vị trí**: `lib/features/{feature}/data/datasources/{feature}_remote_data_source.dart` hoặc `{feature}_local_data_source.dart`
- **Quy tắc**:
  - Có interface (abstract class) và implementation
  - Implementation dùng `@LazySingleton(as: InterfaceName)`
  - Inject `Dio` (remote) hoặc `SharedPreferences` (local)
  - Return `Model`, KHÔNG return `Entity`
  - Throw exception khi có lỗi

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getAllUsers();
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await dio.get('/users/$id');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dio.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
```

#### 2.3. Repository Implementation
- **Vị trí**: `lib/features/{feature}/data/repositories/{feature}_repository_impl.dart`
- **Quy tắc**:
  - Implement interface từ Domain layer
  - Dùng `@LazySingleton(as: InterfaceName)`
  - Convert Model → Entity
  - Wrap result trong `Either<Failure, T>`
  - Xử lý exception và return `Left(Failure)`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final users = await remoteDataSource.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch users: ${e.toString()}'));
    }
  }
}
```

---

### 3. Presentation Layer (UI)

#### 3.1. BLoC Event
- **Vị trí**: `lib/features/{feature}/presentation/bloc/{feature}_event.dart`
- **Quy tắc**:
  - Kế thừa `Equatable`
  - Mỗi event đại diện cho một hành động của user
  - Dùng `const` constructor

```dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends UserEvent {
  final String userId;

  const LoadUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class RefreshUsersEvent extends UserEvent {
  const RefreshUsersEvent();
}
```

#### 3.2. BLoC State
- **Vị trí**: `lib/features/{feature}/presentation/bloc/{feature}_state.dart`
- **Quy tắc**:
  - Kế thừa `Equatable`
  - Có ít nhất: Initial, Loading, Loaded, Error states
  - Dùng `const` constructor

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
```

#### 3.3. BLoC
- **Vị trí**: `lib/features/{feature}/presentation/bloc/{feature}_bloc.dart`
- **Quy tắc**:
  - Kế thừa `Bloc<Event, State>`
  - Dùng `@injectable`
  - Inject UseCase qua constructor
  - Xử lý events và emit states

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../../../core/usecase/usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserById getUserById;
  final GetAllUsers getAllUsers;

  UserBloc({
    required this.getUserById,
    required this.getAllUsers,
  }) : super(const UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<void> _onLoadUser(
    LoadUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    final result = await getUserById(event.userId);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    final result = await getAllUsers(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
```

#### 3.4. Page/Widget
- **Vị trí**: `lib/features/{feature}/presentation/pages/{feature}_page.dart`
- **Quy tắc**:
  - Dùng `BlocProvider` để provide BLoC
  - Inject BLoC qua `getIt<BlocName>()`
  - Dispatch event trong `initState` hoặc user action
  - Dùng `BlocBuilder` hoặc `BlocConsumer` để listen state

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>()..add(LoadUserEvent(userId)),
      child: const UserPageContent(),
    );
  }
}

class UserPageContent extends StatelessWidget {
  const UserPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(const RefreshUsersEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(const RefreshUsersEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text('Name: ${state.user.name}'),
                  const SizedBox(height: 8),
                  Text('Email: ${state.user.email}'),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(const RefreshUsersEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
```

---

## Dependency Injection

### Quy tắc Injectable

1. **Singleton cho services**: Dùng `@lazySingleton` hoặc `@singleton`
   ```dart
   @lazySingleton
   class ApiService { ... }
   ```

2. **Factory cho BLoC**: Dùng `@injectable`
   ```dart
   @injectable
   class UserBloc extends Bloc { ... }
   ```

3. **Interface implementation**: Dùng `as` parameter
   ```dart
   @LazySingleton(as: UserRepository)
   class UserRepositoryImpl implements UserRepository { ... }
   ```

4. **External dependencies**: Tạo module trong `lib/core/di/register_module.dart`
   ```dart
   @module
   abstract class RegisterModule {
     @lazySingleton
     Dio dio(DioClient dioClient) => dioClient.dio;
   }
   ```

5. **Sau khi thêm @injectable**: Chạy code generation
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## Error Handling

### Failure Classes
- **Vị trí**: `lib/core/error/failures.dart`
- **Các loại**:
  - `ServerFailure`: Lỗi từ API
  - `NetworkFailure`: Lỗi mạng
  - `CacheFailure`: Lỗi cache/local storage

```dart
// Trong repository implementation
try {
  final data = await dataSource.getData();
  return Right(data);
} on DioException catch (e) {
  return Left(NetworkFailure('Network error: ${e.message}'));
} catch (e) {
  return Left(ServerFailure('Server error: $e'));
}
```

---

## Checklist khi thêm tính năng mới

### Domain Layer
- [ ] Tạo Entity với Equatable
- [ ] Tạo Repository Interface (abstract class)
- [ ] Tạo UseCase với @lazySingleton

### Data Layer
- [ ] Tạo Model extends Entity với fromJson/toJson
- [ ] Tạo DataSource interface và implementation với @LazySingleton
- [ ] Tạo Repository Implementation với @LazySingleton
- [ ] Xử lý error và return Either<Failure, T>

### Presentation Layer
- [ ] Tạo Event classes với Equatable
- [ ] Tạo State classes với Equatable (Initial, Loading, Loaded, Error)
- [ ] Tạo BLoC với @injectable
- [ ] Tạo Page/Widget với BlocProvider và BlocBuilder
- [ ] Thêm RefreshIndicator nếu cần reload data

### Dependency Injection
- [ ] Chạy `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Kiểm tra không có warning về missing dependencies
- [ ] Test inject BLoC qua `getIt<BlocName>()`

### Testing
- [ ] Chạy `flutter analyze` - phải 0 issues
- [ ] Test loading state
- [ ] Test loaded state với data
- [ ] Test error state
- [ ] Test pull-to-refresh

---

## Ví dụ hoàn chỉnh

Xem implementation của **Dog Images Feature**:
- Domain: `lib/features/home/domain/`
- Data: `lib/features/home/data/`
- Presentation: `lib/features/home/presentation/`

---

## Lưu ý quan trọng

1. **KHÔNG vi phạm dependency rule**:
   - Domain KHÔNG phụ thuộc vào Data hay Presentation
   - Data phụ thuộc vào Domain
   - Presentation phụ thuộc vào Domain

2. **Luôn dùng Either<Failure, T>** cho return type của Repository và UseCase

3. **Model ≠ Entity**:
   - Model: Data layer, có JSON serialization
   - Entity: Domain layer, pure business object

4. **Mỗi UseCase làm MỘT việc duy nhất**

5. **BLoC không gọi trực tiếp Repository**, phải qua UseCase

6. **Sau khi thêm @injectable**, luôn chạy build_runner

7. **Dùng const constructor** cho Event, State, Entity khi có thể

8. **UI không chứa business logic**, chỉ dispatch events và hiển thị states
