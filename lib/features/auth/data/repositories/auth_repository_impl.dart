import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DioClient dioClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.dioClient,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Lưu token và user info
      await localDataSource.saveAuthToken(response.accessToken);
      await localDataSource.saveUserId(response.user.id);

      // Set token cho DioClient
      dioClient.setAuthToken(response.accessToken);

      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      // Lưu token và user info
      await localDataSource.saveAuthToken(response.accessToken);
      await localDataSource.saveUserId(response.user.id);

      // Set token cho DioClient
      dioClient.setAuthToken(response.accessToken);

      return Right(response.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthData();
      dioClient.removeAuthToken();
      return const Right(null);
    } on ServerException catch (e) {
      // Vẫn clear local data ngay cả khi API fail
      await localDataSource.clearAuthData();
      dioClient.removeAuthToken();
      return Left(ServerFailure(e.message));
    } catch (e) {
      await localDataSource.clearAuthData();
      dioClient.removeAuthToken();
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Right(null);
      }

      // Set token cho DioClient
      dioClient.setAuthToken(token);

      // Trong thực tế, bạn có thể call API để lấy thông tin user
      // Ở đây return null vì chưa có API
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }
}
