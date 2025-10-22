// Tela de Boas-Vindas - lib/ui/views/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


//=================================================
//      ---WIDGET PRINCIPAL DA TELA---
//=================================================
// Esta tela é a porta de entrada do aplicativo.
// Ela apresenta o nome do app e dois botões: Login e Cadastro.
// Foi convertida para StatefulWidget para gerenciar o estado de carregamento dos botões.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Variáveis para controlar o estado de carregamento de cada botão
  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;

  // Gradiente padrão para os botões
  static const _buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF318CE7), Color(0xFF1976D2), Color(0xFF0D47A1)],
    stops: [0.0, 0.5, 1.0],
  );

  //=================================================
  //              --- INTERFACE (UI) ---
  //=================================================
  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.of(context).size.width < 600 ? double.infinity : 400.0;
    
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: maxWidth,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.shield_outlined, size: 80, color: colorScheme.primary),
                const SizedBox(height: 20),
                Text(
                  'CyberShield',
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'A sua proteção digital começa aqui',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 70),

                // ========================
                // --- BOTÃO DE LOGIN ---
                // ========================
                _buildLoginButton(context),

                const SizedBox(height: 16),

                // ========================
                // --- BOTÃO DE CADASTRO ---
                // ========================
                _buildSignUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //========================
  // --- BOTÃO DE LOGIN ---
  //========================
  // Este botão leva o usuário para a tela de login.
  // Mostra um indicador de carregamento ao ser pressionado.
  Widget _buildLoginButton(BuildContext context) {
    return InkWell(
      // Desabilita o clique enquanto estiver carregando
      onTap: _isLoginLoading || _isSignUpLoading ? null : () async {
        setState(() => _isLoginLoading = true);
        
        // Simula uma requisição de rede ou processamento
        await Future.delayed(const Duration(seconds: 2));

        // Navega para a próxima tela se o widget ainda estiver montado
        if (mounted) context.go('/login');

        // Reseta o estado de carregamento (útil se o usuário voltar para esta tela)
        if (mounted) setState(() => _isLoginLoading = false);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: _buttonGradient,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          // Mostra o loading ou o texto, dependendo do estado
          child: _isLoginLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Fazer Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
        ),
      ),
    );
  }

  //=============================
  // --- BOTÃO DE CADASTRO ---
  //=============================
  // Este botão leva o usuário para a tela de cadastro.
  // Mostra um indicador de carregamento ao ser pressionado.
  Widget _buildSignUpButton(BuildContext context) {
    return InkWell(
      // Desabilita o clique enquanto estiver carregando
      onTap: _isSignUpLoading || _isLoginLoading ? null : () async {
        setState(() => _isSignUpLoading = true);

        // Simula uma requisição de rede ou processamento
        await Future.delayed(const Duration(seconds: 2));

        // Navega para a próxima tela se o widget ainda estiver montado
        if (mounted) context.go('/cadastro');

        // Reseta o estado de carregamento
        if (mounted) setState(() => _isSignUpLoading = false);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: _buttonGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        // Este Container interno cria o efeito de "borda"
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            // A cor de fundo
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: _isSignUpLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : ShaderMask(
                    shaderCallback: (bounds) => _buttonGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Cor base para o ShaderMask
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
