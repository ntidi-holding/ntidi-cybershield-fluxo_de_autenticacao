import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dto/request/login_request.dart';
import '../network/dto/response/login_response.dart';
import '../models/result.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthService({required FlutterSecureStorage storage, required Dio dio})
    : _storage = storage,
      _dio = dio;

  Future<Result<LoginResponse>> authenticate(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/login',
        data: {
          'email': request.email,
          'password': request.password,
          'remember_me': request.rememberMe,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final login = LoginResponse.fromJson(body);
        if (login.accessToken.isNotEmpty) {
          await _storage.write(key: 'access_token', value: login.accessToken);
        }
        return Result.success(login);
      }
      final errorMsg =
          (response.data?['message'] as String?) ?? 'Erro desconhecido';
      return Result.failure(errorMsg);
    } on DioException catch (e) {
      final msg =
          e.response?.data is Map<String, dynamic> &&
                  (e.response!.data as Map<String, dynamic>)['message'] != null
              ? (e.response!.data['message'] as String)
              : e.message;
      return Result.failure(msg ?? "Erro desconhecido");
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
