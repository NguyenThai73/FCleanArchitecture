import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // MOCK DATA - Sử dụng tài khoản mặc định
    if (email == MockData.defaultEmail && password == MockData.defaultPassword) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      return AuthResponseModel(
        user: const UserModel(
          id: MockData.defaultUserId,
          email: MockData.defaultEmail,
          name: MockData.defaultName,
          avatar: null,
        ),
        accessToken: MockData.mockAccessToken,
        refreshToken: MockData.mockRefreshToken,
      );
    }

    // Nếu không phải tài khoản mặc định, call API thật
    try {
      final response = await dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Login failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Email hoặc mật khẩu không đúng');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // MOCK DATA - Cho phép đăng ký bất kỳ tài khoản nào
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return AuthResponseModel(
      user: UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        avatar: null,
      ),
      accessToken: MockData.mockAccessToken,
      refreshToken: MockData.mockRefreshToken,
    );

    // Uncomment để sử dụng API thật
    /*
    try {
      final response = await dioClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException('Registration failed');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server error');
    }
    */
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Server error');
    }
  }
}
