import 'package:go_router/go_router.dart';
import 'package:ntidi/ui/views/home_screen.dart';
import 'package:ntidi/ui/views/login_sreen.dart';
import 'package:ntidi/ui/views/welcome_screen.dart';

// Imports das telas principais

import '../ui/views/cadastro_screen.dart';


// ==========================================================
//               Telas Principais
// ==========================================================
class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: _routes,
  );
   // Rotas principais
  static final List<GoRoute> _routes = [
    // Rota de Cadastro
    GoRoute(path: '/cadastro',builder: (context, state) => const CadastroScreen()),
    // Rota da tela Home
    GoRoute(path: '/home',builder: (context, state) => const HomeScreen()),
    // Rota da tela Welcome
    GoRoute(path: '/welcome',builder: (context, state) => const WelcomeScreen()),
    // Roda da tela Login
    GoRoute(path: '/login',builder: (context, state) => const LoginScreen()),
  ];
}