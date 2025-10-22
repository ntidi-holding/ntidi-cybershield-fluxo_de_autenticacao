// Tela Principal - lib/ui/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ntidi/core/models/feature_model.dart';
import 'package:ntidi/services/notification_service.dart';

//=================================================
//  TELA PRINCIPAL (HomeScreen)
//=================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Classe da tela principal do aplicativo.
// Ela exibe uma lista de funcionalidades (features) disponíveis para o usuário,
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Feature> _features = [
    //Feature de 'Proteção de Identidade'
    Feature(
        icon: Icons.badge_outlined,
        title: 'Proteção de Identidade',
        routePath: '/protecao-de-identidade',
        requiredPlan: "premium"),
    //Feature de 'Anti-Golpes'
    Feature(
        icon: Icons.qr_code_scanner,
        title: 'Anti Golpes',
        routePath: '/anti-golpes',
        requiredPlan: "premium"),
    //Feature de 'Inteligência Emocional'
    Feature(
        icon: Icons.shield_outlined,
        title: 'Inteligência Emocional',
        routePath: '/inteligencia-emocional',
        requiredPlan: "premium"),
    //Feature de 'Anti-Clonagem'
    Feature(
        icon: Icons.vpn_lock_outlined,
        title: 'Anti-Clonagem',
        routePath: '/anti-clonagem',
        requiredPlan: "premium"),
    //Feature de 'Pós-Vazamento'
    Feature(
        icon: Icons.notifications_active_outlined,
        title: 'Pós-Vazamento',
        routePath: '/pos-vazamento',
        requiredPlan: "premium",
        isInitiallyLocked: true),
    //Feature de 'Comunicação e Notificação'
    Feature(
        icon: Icons.history,
        title: 'Comunicação e Notificação',
        routePath: '/comunicacao-e-notificacao',
        requiredPlan: "premium"),
    //Feature de 'Blindagem Pública'
    Feature(
        icon: Icons.public,
        title: 'Blindagem Pública',
        routePath: '/blindagem-publica',
        requiredPlan: "premium",
        isInitiallyLocked: true),
    //Feature de 'Blindagem de Exposição Pública'
    Feature(
        icon: Icons.shield_moon_outlined,
        title: 'Blindagem de Exposição Pública',
        routePath: '/blindagem-de-exposicao-publica',
        requiredPlan: "premium",
        isInitiallyLocked: true),
    //Feature de 'Gerenciar Assinatura'
    Feature(
        icon: Icons.subscriptions_outlined,
        title: 'Gerenciar Assinatura',
        routePath: '/gerenciar-assinaturas',
        requiredPlan: "premium",
        isActive: true),
    //Feature de 'Suporte/Contato'
    Feature(
        icon: Icons.contact_support_outlined,
        title: 'Suporte/Contato',
        routePath: '/suporte-e-contato',
        requiredPlan: "premium",
        isActive: true),
  ];

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  // Método auxiliar para não tornar o initState assíncrono diretamente.
  Future<void> _setupNotifications() async {
    // Cria uma instância do seu serviço e chama o método de inicialização.
    // Ele cuidará de pedir permissão e obter o token FCM.
    await NotificationService().initNotifications();
  }

  // Exibe um diálogo para solicitar acesso a uma funcionalidade bloqueada.
  void _showRequestAccessDialog(Feature feature) {
    showDialog(
      context: context,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(children: [
              Icon(feature.icon, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(feature.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)))
            ]),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Esta funcionalidade está disponível apenas para usuários com plano premium ou mediante aprovação manual.'),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(children: [
                        Icon(Icons.access_time, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                'Tempo estimado para ativação: até 24h úteis.',
                                style: TextStyle(fontSize: 13)))
                      ]))
                ]),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              OutlinedButton.icon(
                  icon: const Icon(Icons.subscriptions_outlined),
                  label: const Text('Assinar Plano'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/gerenciar-assinaturas');
                  }),
              ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Solicitar Ativação'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Solicitação enviada para: ${feature.title}'),
                        backgroundColor: Colors.green));
                  })
            ]);
      },
    );
  }

  /// Gerencia o toque em um card de funcionalidade.
  /// Se a feature estiver bloqueada ou inativa, mostra o diálogo de acesso.
  /// Caso contrário, navega para a tela da funcionalidade.
  void _handleCardTap(int index) {
    final feature = _features[index];
    if (feature.isInitiallyLocked || !feature.isActive) {
      _showRequestAccessDialog(feature);
    } else {
      context.push(feature.routePath, extra: feature);
    }
  }

  void _toggleFeatureState(int index) {
    setState(() {
      _features[index].isActive = !_features[index].isActive;
    });
  }

  void _activateDevMode() {
    setState(() {
      for (var f in _features) {
        f.isActive = true;
        f.isInitiallyLocked = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Modo desenvolvedor ativado! Todas as funcionalidades liberadas.')));
  }


  //===========================================
  //    --- Barra de Navegação Inferior ---
  //===========================================
  /// Gerencia a navegação da barra inferior e corrige o estado do item selecionado.
  void _onNavBarItemTapped(int index) {
    // Se o usuário clicar no item que já está selecionado, não faz nada.
    if (_selectedIndex == index) return;

    switch (index) {
      case 0: // Home
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1: // Notificações
        context.push('/notificacoes').then((_) {
          if (mounted) {
            // Ao retornar, reseta o índice para a Home.
            setState(() {
              _selectedIndex = 0;
            });
          }
        });
        break;
      case 2: // Perfil
        context.push('/perfil').then((_) {
          if (mounted) {
            // Ao retornar, reseta o índice para a Home.
            setState(() {
              _selectedIndex = 0;
            });
          }
        });
        break;
    }
  }


  // Exibe um diálogo de confirmação para sair do aplicativo.
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: const Text('Confirmar Saída'),
              content: const Text(
                  'Você tem certeza que deseja sair do aplicativo?'),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(dialogContext).pop()),
                TextButton(
                    child: const Text('Sair'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go('/welcome');
                    })
              ]);
        });
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // Obtém o tema de texto atual
    final colorScheme = Theme.of(context).colorScheme; // Obtém o esquema de cores atual
    final screenWidth = MediaQuery.of(context).size.width; // Obtém a largura da tela

    // Nome do usuário fictício para exibição
    const userName = "Victor Kauê";

    //Responsividade - Ajusta o número de colunas com base na largura da tela
    int crossAxisCount;
    if (screenWidth > 1200) { // Se a largura da tela for maior que 1200, usa 4 colunas;
      crossAxisCount = 4;
    } else if (screenWidth > 800) { //Se for maior que 800, usa 3;
      crossAxisCount = 3;
    } else if (screenWidth < 380) { //se for menor que 380, usa 2; caso contrário, usa 2.
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }


    // Cor azul para a barra de navegação
    const Color appBarBlue = Color(0xFF0D63C1);
    // Retorna o widget Scaffold que representa a tela principal do aplicativo
    // Ele contém a barra de navegação, o corpo principal e a barra de navegação
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        title: const Row(children: [
          Icon(Icons.shield, color: appBarBlue, size: 24),
          SizedBox(width: 8),
          Text('CyberShield',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: appBarBlue))
        ]),
        actions: [
          TextButton(
              onPressed: _activateDevMode,
              child:
                  const Text('Modo Dev', style: TextStyle(color: appBarBlue))),
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              color: appBarBlue,
              onPressed: _showLogoutDialog),
          const SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 28,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Olá,', style: textTheme.bodyMedium),
                            Text(
                              userName,
                              style: textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Título da seção de serviços
                    Text(
                      'Serviços ',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Exibe uma grade de cards com as funcionalidades disponíveis
            // A grade é responsiva e se adapta ao tamanho da tela
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 80.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _FeatureCard(
                      feature: _features[index],
                      onTap: () => _handleCardTap(index),
                      onBadgeTap: () => _toggleFeatureState(index),
                    );
                  },
                  childCount: _features.length,
                ),
              ),
            ),
          ],
        ),
      ),
      // Barra de navegação inferior com três itens: Home, Notificações e Perfil
      // Cada item tem um ícone e um rótulo, e a navegação é gerenciada pelo método _onNavBarItemTapped
      // O índice do item selecionado é armazenado em _selectedIndex
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notificações'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Perfil')
          ],
          currentIndex: _selectedIndex,
          onTap: _onNavBarItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true),
    );
  }
}

//=================================================
//  COMPONENTE DE CARD (_FeatureCard)
//=================================================
class _FeatureCard extends StatelessWidget {
  final Feature feature;
  final VoidCallback onTap;
  final VoidCallback onBadgeTap;

  const _FeatureCard({
    required this.feature,
    required this.onTap,
    required this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = feature.isInitiallyLocked;
    final bool isActive = feature.isActive;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final Color backgroundColor;
    final Color contentColor;
    final String statusText;
    final String actionText;


    if (isLocked) { // Se a funcionalidade estiver bloqueada, exibe o status de bloqueio
      backgroundColor = colorScheme.surfaceContainerHighest;
      contentColor = colorScheme.onSurfaceVariant;
      statusText = 'Requer Upgrade';
      actionText = 'Solicitar Acesso';
    } else if (isActive) { // Se a funcionalidade estiver ativa, exibe o status de ativo
      backgroundColor = colorScheme.primary;
      contentColor = colorScheme.onPrimary;
      statusText = 'Ativo';
      actionText = 'Acessar';
    } else { // Se a funcionalidade estiver inativa, exibe o status de inativo
      backgroundColor = colorScheme.surfaceContainerHighest;
      contentColor = colorScheme.onSurfaceVariant;
      statusText = 'Em análise';
      actionText = 'Solicitar Acesso';
    }
    
    // Retorna o widget GestureDetector que detecta toques no card
    // O card exibe o ícone, título, status e um botão de ação
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(feature.icon, color: contentColor, size: 28),
                  const SizedBox(height: 6),
                  Expanded(
                      child: Text(feature.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                              color: contentColor,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 4),
                  Text(statusText,
                      style: textTheme.labelSmall?.copyWith(color: contentColor)),
                  const SizedBox(height: 4),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: contentColor.withOpacity(0.1),
                              foregroundColor: contentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: const Size(0, 36)),
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(actionText,
                                  style: const TextStyle(fontSize: 12)))))
              ]
            )
         )      
      );
  }
}

