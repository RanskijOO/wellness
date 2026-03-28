import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/app_tokens.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AloeSpacing.lg,
            AloeSpacing.sm,
            AloeSpacing.lg,
            AloeSpacing.lg,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AloeRadii.lg,
              gradient: LinearGradient(
                colors: dark
                    ? <Color>[
                        AloeColors.darkCard.withValues(alpha: 0.98),
                        AloeColors.darkElevated.withValues(alpha: 0.96),
                      ]
                    : <Color>[
                        Colors.white.withValues(alpha: 0.94),
                        AloeColors.cloud.withValues(alpha: 0.92),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AloeColors.forest.withValues(alpha: 0.08),
              ),
              boxShadow: AloeShadows.elevated(dark),
            ),
            child: ClipRRect(
              borderRadius: AloeRadii.lg,
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                    icon: Icon(Icons.today_outlined),
                    selectedIcon: Icon(Icons.today),
                    label: 'Сьогодні',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.show_chart_outlined),
                    selectedIcon: Icon(Icons.show_chart),
                    label: 'Прогрес',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.checklist_rtl_outlined),
                    selectedIcon: Icon(Icons.checklist_rtl),
                    label: 'Плани',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.local_florist_outlined),
                    selectedIcon: Icon(Icons.local_florist),
                    label: 'Каталог',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Профіль',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
