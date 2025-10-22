import 'package:flutter/foundation.dart';
import '../../core/models/result.dart';
import '../../core/network/dto/request/login_request.dart';
import '../../core/repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _repository;
  final ValueNotifier<Result<bool>> loginState = ValueNotifier(
    Result.success(false),
  );

  AuthViewModel(this._repository);

  Future<Result<bool>>? login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    final request = LoginRequest(email, password, rememberMe);
    loginState.value = Result.success(false);
    try {
      final result = await _repository.authenticate(request);
      loginState.value =
          result.isSuccess
              ? Result.success(true)
              : Result.failure(
                result.message ?? "Usuário ou senha incorretos!",
              );
    } catch (e) {
      loginState.value = Result.failure(e.toString());
    }
    return loginState.value;
  }
}
