import 'package:ntidi/core/network/dto/response/login_response.dart';
import 'package:ntidi/core/services/auth_service.dart';

import '../models/result.dart';
import '../network/dto/request/login_request.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

  Future<Result<LoginResponse>> authenticate(LoginRequest request) async {
    try {
      final response = await service.authenticate(request);
      if (response.isSuccess) {
        final result = response.result;
        if (result != null) {
          return Result.success(result);
        } else {
          return Result.failure("Resposta de login vazia do servidor!");
        }
      } else {
        return Result.failure(response.message ?? "Erro desconhecido!");
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
