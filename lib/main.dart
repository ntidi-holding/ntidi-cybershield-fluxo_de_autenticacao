import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/theme/theme.dart';
import 'ui/theme/theme_utils.dart';
import 'core/network/auth_interceptor.dart';
import 'routes/app_router.dart';
import 'di/di.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    // A inicialização é chamada aqui, apenas uma vez na vida do widget.
    _initialization = _initializeApp();
  }


  Future<void> _initializeApp() async {
    // Garante que os bindings do Flutter estejam prontos.
    WidgetsFlutterBinding.ensureInitialized();
    
    // Suas inicializações assíncronas
    await initializeDateFormatting('pt_BR', null);
    await dotenv.load(fileName: ".env");
    await setupDI();
    await GetIt.instance.allReady();
    setupInterceptors();
    
    // Configurações do SystemChrome
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Se ainda estiver carregando, mostra uma tela de loading.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Se ocorrer um erro na inicialização, mostra uma tela de erro.
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Erro ao iniciar o app: ${snapshot.error}'),
              ),
            ),
          );
        }

        // Se a inicialização for concluída com sucesso, mostra o app.
        TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
        MaterialTheme theme = MaterialTheme(textTheme);

        return MaterialApp.router(
          title: 'CyberShield',
          debugShowCheckedModeBanner: false,
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: ThemeMode.light,
          routerConfig: getIt<AppRouter>().router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
        );
      },
    );
  }
}