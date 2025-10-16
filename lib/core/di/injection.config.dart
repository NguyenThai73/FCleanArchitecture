// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../config/routes/app_router.dart' as _i20;
import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/home/data/datasources/dog_remote_data_source.dart'
    as _i30;
import '../../features/home/data/repositories/dog_repository_impl.dart'
    as _i1031;
import '../../features/home/domain/repositories/dog_repository.dart' as _i973;
import '../../features/home/domain/usecases/get_dog_images.dart' as _i935;
import '../../features/home/presentation/bloc/dog_images_bloc.dart' as _i1040;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
    gh.lazySingleton<_i992.AuthLocalDataSource>(
        () => _i992.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i361.Dio>(
        () => registerModule.dio(gh<_i667.DioClient>()));
    gh.lazySingleton<_i30.DogRemoteDataSource>(
        () => _i30.DogRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i973.DogRepository>(
        () => _i1031.DogRepositoryImpl(gh<_i30.DogRemoteDataSource>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
          localDataSource: gh<_i992.AuthLocalDataSource>(),
          dioClient: gh<_i667.DioClient>(),
        ));
    gh.lazySingleton<_i935.GetDogImages>(
        () => _i935.GetDogImages(gh<_i973.DogRepository>()));
    gh.lazySingleton<_i941.RegisterUseCase>(
        () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i48.LogoutUseCase>(
        () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.singleton<_i20.AppRouter>(
        () => _i20.AppRouter(gh<_i787.AuthRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          loginUseCase: gh<_i188.LoginUseCase>(),
          registerUseCase: gh<_i941.RegisterUseCase>(),
          logoutUseCase: gh<_i48.LogoutUseCase>(),
        ));
    gh.factory<_i1040.DogImagesBloc>(
        () => _i1040.DogImagesBloc(gh<_i935.GetDogImages>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
