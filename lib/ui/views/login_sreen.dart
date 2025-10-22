// Tela de Login - lib/ui/views/login_sreen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/snackbar_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // == Controllers & Form Key ==
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _emailError;
  String? _passwordError;

  //=================
  // --- State ---
  //=================
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _isLoading = false;


  // == Constants ==
  static const _borderRadius = Radius.circular(12);
  static const _padding = EdgeInsets.all(16);

  // == Listeners para validação ==
  void _emailListener() => _validateEmail(_email.text);
  void _passwordListener() => _validatePassword(_password.text);

  @override
  void initState() {
    super.initState();

    // Inicia os controllers com os valores de teste
    _email = TextEditingController(text: 'teste@teste.com');
    _password = TextEditingController(text: '123456');

    // Adiciona listeners para validar em tempo real
    _email.addListener(_emailListener);
    _password.addListener(_passwordListener);


    // Validação inicial para o botão começar habilitado
    _validateEmail(_email.text);
    _validatePassword(_password.text);
  }

  @override
  void dispose() {
    // É importante remover os listeners para evitar memory leaks
    _email.removeListener(_emailListener);
    _password.removeListener(_passwordListener);
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _email.text.isNotEmpty &&
      _password.text.isNotEmpty;

  void _togglePasswordVisibility() {
    setState(() => _showPassword = !_showPassword);
  }

  void _toggleRememberMe() {
    setState(() => _rememberMe = !_rememberMe);
  }
  
  
  Future<void> _onSubmit() async {
    if (!_isFormValid || _isLoading) return;
    setState(() => _isLoading = true);

    // --- MOCK LOGIN (SEM API) ---
    // Simula um tempo de espera da rede para o loading aparecer
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Verifica as credenciais estáticas definidas no initState
    if (_email.text.trim() == 'teste@teste.com' &&
        _password.text.trim() == '123456') {
      // Sucesso: Navega para a home
      context.go('/home');
    } else {
      // Falha: Mostra um erro e para o loading
      showError(context, 'E-mail ou senha inválidos.');
      setState(() => _isLoading = false);
    }
    // --- FIM DO MOCK LOGIN ---
  }

  //=========================
  // Responsividade e Layout
  //=========================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Define a largura máxima para telas pequenas e grandes
    final maxWidth =
        MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width
            : 400.0;

    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      appBar: AppBar(
        // Removi o título para dar mais destaque ao logo
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/welcome'); // volta corretamente para a tela de welcome
          },
        ),
      ),
      
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: maxWidth,
            padding: _padding,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo e título agora são consistentes com a tela de welcome
                  _buildHeader(theme.textTheme, theme.colorScheme),
                  const SizedBox(height: 48), // Ajuste de espaçamento
                  _buildEmailField(theme),
                  const SizedBox(height: 24),
                  _buildPasswordField(theme),
                  const SizedBox(height: 12),
                  _buildRememberMeRow(theme),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildForgotPassword(theme),
                  const SizedBox(height: 80),
                  _buildCreateAccount(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //=========================
  //Logos e validações
  //=========================
  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
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
      ],
    );
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Por favor, insira seu e-mail';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        _emailError = 'Por favor, insira um endereço de e-mail válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Por favor, insira sua senha';
      } else if (value.length < 6) {
        _passwordError = 'A senha deve ter pelo menos 6 caracteres';
      } else {
        _passwordError = null;
      }
    });
  }
  
  Widget _buildEmailField(ThemeData theme) {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'E-mail',
        errorText: _emailError,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(_borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(_borderRadius),
          borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextFormField(
      controller: _password,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        hintText: 'Senha',
        errorText: _passwordError,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.lock_outlined, size: 20, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(_borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(_borderRadius),
          borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }

  Widget _buildRememberMeRow(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          activeColor: const Color(0xFF1976D2),
          onChanged: (_) => _toggleRememberMe(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        GestureDetector(
          onTap: _toggleRememberMe,
          child: const Text(
            'Permanecer conectado?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Opacity(
      opacity: (_isFormValid && !_isLoading) ? 1 : 0.6,
      child: InkWell(
        onTap: _isFormValid ? _onSubmit : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 56,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF318CE7), Color(0xFF1976D2), Color(0xFF0D47A1)],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center( 
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                  )
                : const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.8),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(ThemeData theme) {
    return TextButton(
      onPressed: () => context.go('/esquece-senha'),
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF1976D2)),
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCreateAccount(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Não tem uma conta?',
          style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => context.go('/cadastro'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1976D2),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: const Text(
            'Crie sua conta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
