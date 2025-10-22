import 'package:dio/dio.dart';
import 'package:ntidi/core/repositories/auth_repository.dart';
import 'package:ntidi/ui/viewmodels/auth_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/services/auth_service.dart';
import '../routes/app_router.dart';

final getIt = GetIt.instance;
final baseUrl = dotenv.get('BASE_URL');

Future<void> setupDI() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      webOptions: WebOptions(dbName: 'storage', publicKey: 'storage'),
    ),
  );

  // Network
  getIt.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // 2) Service
  getIt.registerLazySingleton<AuthService>(
    () =>
        AuthService(storage: getIt<FlutterSecureStorage>(), dio: getIt<Dio>()),
  );

  // 3) Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(service: getIt<AuthService>()),
  );

  // 4) ViewModel
  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(getIt<AuthRepository>()),
  );
}
