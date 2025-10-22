// Esse arquivo configura um interceptor para adicionar automaticamente o token de autenticação nas requisições HTTP.
// Ele é usado para fazer as chamativas de API (GET, POST, PUT, etc.)
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../di/di.dart';

setupInterceptors() {
  final dio = getIt<Dio>();
  dio.interceptors.add(AuthInterceptor(getIt<FlutterSecureStorage>()));
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthRequest = options.path.contains('auth/login');
    if (!isAuthRequest) {
      final token = await _storage.read(key: 'access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
