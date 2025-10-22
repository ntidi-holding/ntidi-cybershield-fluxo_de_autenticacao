// pasta para controle de respostas de login
class LoginResponse {
  final String accessToken;
  final String userName;
  final String email;
  final List<String> roles;

  LoginResponse({
    required this.accessToken,
    required this.userName,
    required this.email,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      userName: json['user']['name'] as String,
      email: json['user']['email'] as String,
      roles: json['user']['roles'] as List<String>,
    );
  }
}
