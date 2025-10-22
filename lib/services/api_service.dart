// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiService {

  static const String _backendUrl = 'https://theda-precisive-unpunctually.ngrok-free.dev/register-device';

  static Future<void> sendFcmToken(String token) async {
    try {

      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode({
          'sender_id': 'flutter_user_123', // Use um ID de usuário real aqui!
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Token FCM enviado para o servidor com sucesso.');
      } else {
        debugPrint('Falha ao enviar token FCM. Status: ${response.statusCode}');
        debugPrint('Resposta: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro de rede ao enviar token FCM: $e');
    }
  }
}