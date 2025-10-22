// lib/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Verifique se o caminho para seu api_service.dart está correto
import 'api_service.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  // --- NOVO: Instância do plugin de notificações locais ---
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // --- NOVO: Canal de notificação para Android (essencial para Android 8.0+) ---
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // ID do Canal
    'High Importance Notifications', // Título do Canal
    description: 'Este canal é usado para notificações importantes.', // Descrição
    importance: Importance.high,
  );

  // --- NOVO: Método para inicializar o plugin de notificações locais ---
  Future<void> _initializeLocalNotifications() async {
    // Ícone padrão para a notificação no Android.
    // Ele deve existir em 'android/app/src/main/res/mipmap/ic_launcher.png'
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configurações para iOS
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Função principal para ser chamada no início da aplicação (ex: na home_screen)
  Future<void> initNotifications() async {
    // --- ALTERADO: Inicializa o plugin de notificações locais ---
    await _initializeLocalNotifications();
    
    // --- ALTERADO: Cria o canal de notificação no dispositivo Android ---
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 1. Pedir permissão ao usuário
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permissão de notificação concedida.');

      // 2. Obter o token e configurar listeners
      await _getTokenAndSendToServer();
      _fcm.onTokenRefresh.listen((newToken) async {
        debugPrint('Token FCM atualizado: $newToken');
        await ApiService.sendFcmToken(newToken);
      });
      
      // 3. Configurar os handlers de mensagem
      _setupMessageHandlers();

    } else {
      debugPrint('Permissão de notificação negada.');
    }
  }

  // Obtém o token e envia para o backend (sem alterações)
  Future<void> _getTokenAndSendToServer() async {
    try {
      final fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        debugPrint('--- SEU TOKEN FCM ---');
        debugPrint(fcmToken);
        debugPrint('---------------------');
        await ApiService.sendFcmToken(fcmToken);
      }
    } catch (e) {
      debugPrint('Erro ao obter ou enviar o token FCM: $e');
    }
  }

  // Configura como o app reage às notificações
  void _setupMessageHandlers() {
    // --- ALTERADO: Lógica para mostrar notificação com o app ABERTO ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Recebida mensagem em primeiro plano: ${message.notification?.title}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Se a notificação existir, usamos o plugin para mostrá-la na tela
      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon, // Usa o ícone padrão definido
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Handler para quando o usuário clica na notificação com o app em BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App aberto a partir de notificação em segundo plano: ${message.notification?.title}');
      // Aqui você pode adicionar lógica de navegação se quiser
    });
    
    // Handler para quando o usuário clica na notificação com o app TERMINADO
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
         debugPrint('App aberto a partir de notificação com o app terminado: ${message.notification?.title}');
         // Aqui você pode adicionar lógica de navegação se quiser
      }
    });
  }
}