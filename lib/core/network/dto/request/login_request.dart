// pasta para controle de requisições de login
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequest(this.email, this.password, this.rememberMe);

  factory LoginRequest.fromMap(Map<String, dynamic> map) {
    return LoginRequest(
      map['email'] as String,
      map['password'] as String,
      map['rememberMe'] as bool,
    );
  }

// Converte o objeto LoginRequest em um mapa JSON 
  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }
}
