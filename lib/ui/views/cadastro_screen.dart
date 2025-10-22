// Tela de Cadastro - lib/ui/views/cadastro_screen.dart

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

enum TipoPessoa { pf, pj }

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  TipoPessoa _tipoPessoaSelecionado = TipoPessoa.pf;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _rgController = TextEditingController();
  final _orgaoEmissorController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _ufController = TextEditingController();
  final _redesSociaisController = TextEditingController();
  final _razaoSocialController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _cnaeController = TextEditingController();
  final _dominioAdicionalController = TextEditingController();
  final _repLegalNomeController = TextEditingController();
  final _repLegalCpfController = TextEditingController();
  final _repLegalComplementoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfFormatter =
      MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
  final _phoneFormatter =
      MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _dataNascimentoFormatter =
      MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _cepFormatter =
      MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _autorizaConsultaCredito = false;
  bool _autorizaConsultaPublica = false;
  static const _borderRadius = Radius.circular(12);
  static const _padding = EdgeInsets.symmetric(horizontal: 24.0);

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigits = false;
  bool _hasSymbols = false;

  // Variaveis para o timer do Codigo OTP
  Timer? _timer;
  int _countdown = 30;
  bool _isButtonDisabled = false;

  /// Alterne entre`true` e `false` para ativar/desativar o modo de teste.
  final bool _isTestMode = true;

  // Escolha o tipo de formulário a ser testado.
  final TipoPessoa _tipoPessoaParaTeste = TipoPessoa.pj; // ou TipoPessoa.pf

  @override
  void initState() {
    super.initState();

    _preencherDadosParaTeste();

    _passwordController.addListener(_updatePasswordStrength);
  }

  void _preencherDadosParaTeste() {
    if (!_isTestMode) return;

    setState(() {
      _tipoPessoaSelecionado = _tipoPessoaParaTeste;

      if (_tipoPessoaSelecionado == TipoPessoa.pf) {
        // Preenche dados específicos de Pessoa Física (conforme imagem 1)
        _nameController.text = 'bracto';
        _emailController.text = '7bracto@example.com';
        _phoneController.text = '(85) 99999-9999';
        _passwordController.text = '73nh@Fort312';
        _confirmPasswordController.text = '73nh@Fort312';
        _cpfController.text = '100.354.700-11';
        _rgController.text = '12.345.678-9';
        _orgaoEmissorController.text = 'SSP-SP';
        _dataNascimentoController.text = '15/03/1985';
        _nomeMaeController.text = 'Maria Oliveira';
        _autorizaConsultaCredito = true;
        _cepController.text = '01001-000';
        _logradouroController.text = 'Praça da Sé';
        _ufController.text = 'SP';
        _redesSociaisController.text = '@bracto';
      } else {
        // Preenche dados específicos de Pessoa Jurídica (conforme imagem 2)
        _nameController.text = 'bracto'; // "fullName" do JSON
        _emailController.text = '6bracto@example.com';
        _phoneController.text = '(95) 99999-9999';
        _passwordController.text = 'j3nh@Fort312';
        _confirmPasswordController.text = 'j3nh@Fort312';
        // CORRIGIDO: Adicionada máscara ao CNPJ
        _cnpjController.text = '48.790.510/0001-36'; // "document" do JSON
        _razaoSocialController.text = 'Empresa Exemplo LTDA'; // "corporateName"
        _nomeFantasiaController.text = 'Exemplo Comércio'; // "tradeName"
        _cnaeController.text = '6201-5/00'; // "mainCnae"
        _dominioAdicionalController.text =
            'exemplo.com,exemplo.net'; // "additionalDomains"
        _repLegalNomeController.text = 'João Silva'; // "legalRepresentativeName"
        // CORRIGIDO: Adicionada máscara ao CPF do Representante Legal
        _repLegalCpfController.text =
            '123.456.789-09'; // "legalRepresentativeCpf"
        _repLegalComplementoController.text = 'Sala 101'; // "complement"
        _autorizaConsultaPublica = true; // "authorizedPjCheck"
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _passwordController.removeListener(_updatePasswordStrength);
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _cnpjController.dispose();
    _phoneController.dispose();
    _smsCodeController.dispose();
    _rgController.dispose();
    _orgaoEmissorController.dispose();
    _dataNascimentoController.dispose();
    _nomeMaeController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _ufController.dispose();
    _redesSociaisController.dispose();
    _razaoSocialController.dispose();
    _nomeFantasiaController.dispose();
    _cnaeController.dispose();
    _dominioAdicionalController.dispose();
    _repLegalNomeController.dispose();
    _repLegalCpfController.dispose();
    _repLegalComplementoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    String password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 12;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasSymbols =
          password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'));
    });
  }

  void _nextPageOrSubmit() {
    bool isStepValid = false;
    if (_currentPage == 0) {
      isStepValid = _formKeyStep1.currentState!.validate();
    } else if (_currentPage == 1) {
      isStepValid = _formKeyStep2.currentState!.validate();
    } else if (_currentPage == 2) {
      isStepValid = _formKeyStep3.currentState!.validate();
    } else if (_currentPage == 3) {
      isStepValid = _formKeyStep4.currentState!.validate();
    }

    if (isStepValid) {
      if (_currentPage < 3) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _submitRegistration();
      }
    }
  }

  void _previousPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _startResendTimer() {
    setState(() {
      _isButtonDisabled = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isButtonDisabled = false;
          _countdown = 30; // Reseta para a próxima vez
        });
      }
    });
  }

  Future<void> _submitRegistration() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: const Icon(Icons.check_circle_outline,
              color: Colors.green, size: 60),
          title: const Text('Cadastro Realizado!', textAlign: TextAlign.center),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Sua conta foi criada com sucesso. Agora você já pode fazer o login.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Ir para Login'),
              onPressed: () {
                context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }

  String _generateStrongPassword() {
    const String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lower = 'abcdefghijklmnopqrstuvwxyz';
    const String digits = '0123456789';
    const String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    const int passwordLength = 14;
    const String allChars = '$upper$lower$digits$symbols';

    Random random = Random.secure();

    String password = upper[random.nextInt(upper.length)] +
        lower[random.nextInt(lower.length)] +
        digits[random.nextInt(digits.length)] +
        symbols[random.nextInt(symbols.length)];

    password += List.generate(passwordLength - 4,
            (index) => allChars[random.nextInt(allChars.length)]).join();

    List<String> passwordChars = password.split('');
    passwordChars.shuffle(random);

    return passwordChars.join();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 400.0;

    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_currentPage > 0) {
              _previousPage();
            } else {
              context.go('/welcome');
            }
          },
        ),
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          padding: _padding,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                    _buildStep4(),
                  ],
                ),
              ),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContainer({
    required GlobalKey<FormState> formKey,
    required String title,
    required int step,
    required List<Widget> children,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Etapa $step de 4',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return _buildStepContainer(
      formKey: _formKeyStep1,
      title: 'Dados Pessoais',
      step: 1,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Nome completo',
          icon: Icons.person_outline,
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'E-mail',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obrigatório';
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'E-mail inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        SegmentedButton<TipoPessoa>(
          segments: const [
            ButtonSegment(
                value: TipoPessoa.pf,
                label: Text('Pessoa Física'),
                icon: Icon(Icons.person)),
            ButtonSegment(
                value: TipoPessoa.pj,
                label: Text('Pessoa Jurídica'),
                icon: Icon(Icons.business)),
          ],
          selected: {_tipoPessoaSelecionado},
          onSelectionChanged: (Set<TipoPessoa> newSelection) {
            setState(() => _tipoPessoaSelecionado = newSelection.first);
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            selectedBackgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            selectedForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _tipoPessoaSelecionado == TipoPessoa.pf
              ? _cpfController
              : _cnpjController,
          label: _tipoPessoaSelecionado == TipoPessoa.pf ? 'CPF' : 'CNPJ',
          icon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [
            _tipoPessoaSelecionado == TipoPessoa.pf
                ? _cpfFormatter
                : _cnpjFormatter
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            final expectedLength =
                _tipoPessoaSelecionado == TipoPessoa.pf ? 14 : 18;
            if (value.length != expectedLength) {
              final docName =
                  _tipoPessoaSelecionado == TipoPessoa.pf ? 'CPF' : 'CNPJ';
              return 'Preencha todos os dígitos do $docName.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return _buildStepContainer(
      formKey: _formKeyStep2,
      title: 'Complete seu perfil',
      step: 2,
      children: [
        //Linha de Telefone e Botão
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: _phoneController,
                label: 'Telefone com DDD',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (value.length != 15) {
                    return 'Telefone inválido. Inclua o DDD.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                backgroundColor: _isButtonDisabled ? Colors.grey.shade300 : null,
                foregroundColor: _isButtonDisabled ? Colors.grey.shade600 : null,
              ),
              onPressed: _isButtonDisabled ? null : _startResendTimer,
              child: const Text('Enviar código'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            // Estilo do texto
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey.shade800,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Digite o código de 6 dígitos enviado por SMS para o número\n'),
              // Estilo para o número de telefone (em negrito)
              TextSpan(
                text: _phoneController.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSmsCodeField(),
        const SizedBox(height: 16),
        Visibility(
          visible: _isButtonDisabled,
          child: Center(
            child: Text(
              'Não recebeu o código? Reenviar em $_countdown segundos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return _tipoPessoaSelecionado == TipoPessoa.pf
        ? _buildStep3PF()
        : _buildStep3PJ();
  }

  Widget _buildStep3PF() {
    return _buildStepContainer(
      formKey: _formKeyStep3,
      title: 'Dados Complementares',
      step: 3,
      children: [
        _buildTextField(
            controller: _rgController,
            label: 'RG',
            icon: Icons.badge,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _orgaoEmissorController,
            label: 'Orgão Emissor',
            icon: Icons.account_balance,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _dataNascimentoController,
            label: 'Data de Nascimento',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            inputFormatters: [_dataNascimentoFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo obrigatório';
              if (value.length != 10) return 'Formato esperado: DD/MM/AAAA.';
              return null;
            }),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nomeMaeController,
          label: 'Nome da Mãe',
          icon: Icons.woman,
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
          suffixIcon: _buildInfoIcon(
              'Essa informação é usada para verificação de segurança e recuperação de conta.'),
        ),
        const SizedBox(height: 24),
        const Text("Endereço", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _cepController,
            label: 'CEP',
            icon: Icons.map,
            keyboardType: TextInputType.number,
            inputFormatters: [_cepFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo obrigatório';
              if (value.length != 9) return 'CEP inválido.';
              return null;
            }),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _buildTextField(
                    controller: _logradouroController,
                    label: 'Logradouro',
                    icon: Icons.signpost,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obrigatório'
                        : null)),
            const SizedBox(width: 8),
            SizedBox(
                width: 80,
                child: _buildTextField(
                    controller: _ufController,
                    label: 'UF',
                    icon: Icons.location_city_sharp,
                    validator: (value) {
                      if (value == null || value.length != 2) {
                        return 'UF inválido';
                      }
                      return null;
                    })),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _redesSociaisController,
            label: 'Redes Sociais (opcional)',
            icon: Icons.share),
        const SizedBox(height: 16),
        Row(children: [
          Checkbox(
              value: _autorizaConsultaCredito,
              onChanged: (v) => setState(() => _autorizaConsultaCredito = v!)),
          const Expanded(
              child: Text('Autorizo consulta em bureaus de crédito')),
        ]),
      ],
    );
  }

  Widget _buildStep3PJ() {
    return _buildStepContainer(
      formKey: _formKeyStep3,
      title: 'Dados Complementares',
      step: 3,
      children: [
        _buildTextField(
            controller: _razaoSocialController,
            label: 'Razão Social',
            icon: Icons.business,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nomeFantasiaController,
          label: 'Nome Fantasia',
          icon: Icons.store,
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
          suffixIcon: _buildInfoIcon('Nome popular ou comercial da empresa.'),
        ),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _cnaeController,
            label: 'CNAE Principal',
            icon: Icons.pin,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
            suffixIcon: _buildInfoIcon(
                'Classificação Nacional de Atividades Econômicas. Ajuda a identificar a área de atuação da sua empresa.')),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _dominioAdicionalController,
            label: 'Domínios Adicionais (opcional)',
            icon: Icons.web),
        const SizedBox(height: 24),
        const Text("Representante Legal",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _repLegalNomeController,
            label: 'Nome',
            icon: Icons.person,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _repLegalCpfController,
            label: 'CPF',
            icon: Icons.badge,
            keyboardType: TextInputType.number,
            inputFormatters: [_cpfFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo obrigatório';
              if (value.length != 14) {
                return 'Preencha todos os dígitos do CPF.';
              }
              return null;
            }),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _repLegalComplementoController,
            label: 'Complemento',
            icon: Icons.note_alt,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null),
        const SizedBox(height: 16),
        Row(children: [
          Checkbox(
              value: _autorizaConsultaPublica,
              onChanged: (v) => setState(() => _autorizaConsultaPublica = v!)),
          const Expanded(child: Text('Autorizo consulta em bases públicas PJ')),
        ]),
      ],
    );
  }

  Widget _buildStep4() {
    return _buildStepContainer(
      formKey: _formKeyStep4,
      title: 'Segurança da Conta',
      step: 4,
      children: [
        _buildTextField(
          controller: _passwordController,
          label: 'Crie uma senha',
          icon: Icons.lock_outline,
          obscureText: !_showPassword,
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off,
                size: 20, color: Colors.grey),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'A senha é obrigatória';
            final allChecksPassed = _hasMinLength &&
                _hasUppercase &&
                _hasLowercase &&
                _hasDigits &&
                _hasSymbols;
            if (!allChecksPassed) {
              return 'A senha não atende a todos os critérios de segurança.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'Confirme sua senha',
          icon: Icons.lock_outline,
          obscureText: !_showConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
                _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.grey),
            onPressed: () =>
                setState(() => _showConfirmPassword = !_showConfirmPassword),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Confirme sua senha';
            if (value != _passwordController.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Gerar senha forte'),
            onPressed: () {
              final newPassword = _generateStrongPassword();
              _passwordController.text = newPassword;
              _confirmPasswordController.text = newPassword;

              Clipboard.setData(ClipboardData(text: newPassword));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Senha forte gerada e copiada!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStrengthIndicatorItem('Mínimo de 12 caracteres', _hasMinLength),
        const SizedBox(height: 4),
        _buildStrengthIndicatorItem(
            'Pelo menos uma letra maiúscula (A-Z)', _hasUppercase),
        const SizedBox(height: 4),
        _buildStrengthIndicatorItem(
            'Pelo menos uma letra minúscula (a-z)', _hasLowercase),
        const SizedBox(height: 4),
        _buildStrengthIndicatorItem('Pelo menos um número (0-9)', _hasDigits),
        const SizedBox(height: 4),
        _buildStrengthIndicatorItem(
            'Pelo menos um símbolo (!@#\$...)', _hasSymbols),
      ],
    );
  }

  Widget _buildStrengthIndicatorItem(String text, bool isMet) {
    final color = isMet ? Colors.green : Colors.grey;
    return Row(
      children: [
        Icon(isMet ? Icons.check_circle : Icons.remove_circle_outline,
            color: color, size: 18),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  // MÉTODO ALTERADO PARA NOVO ESTILO DOS BOTÕES
  Widget _buildBottomNavBar() {
    final isLastStep = _currentPage == 3;
    final buttonText = isLastStep ? 'Concluir' : 'Próximo';

    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                style: buttonStyle,
                onPressed: _previousPage,
                child: const Text('Voltar'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: _isLoading ? null : _nextPageOrSubmit,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
      ],
    );
  }

  Widget _buildInfoIcon(String message) {
    return Tooltip(
      message: message,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      showDuration: const Duration(seconds: 5),
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white),
      child: const Icon(Icons.info_outline, color: Colors.grey, size: 20),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        errorMaxLines: 2,
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey),
        labelStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[200],
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

  // NOVO WIDGET PARA O CAMPO DE CÓDIGO SMS
  Widget _buildSmsCodeField() {
    // Define o estilo padrão dos quadradinhos
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Pinput(
      length: 6, // O número de quadradinhos
      controller: _smsCodeController,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira o código';
        }
        if (value.length < 6) {
          return 'O código deve ter 6 dígitos.';
        }
        return null;
      },
      // Estilos para diferentes estados do campo
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }
}

