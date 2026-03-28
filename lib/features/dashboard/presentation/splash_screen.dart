import 'package:flutter/material.dart';

import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AloePageBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AloeSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const AloeIconBadge(
                  icon: Icons.eco_outlined,
                  size: 92,
                  circular: true,
                ),
                const SizedBox(height: AloeSpacing.xl),
                Text(
                  'Aloe Wellness Coach',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AloeSpacing.md),
                Text(
                  'Підготовка вашого спокійного wellness-простору...',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AloeSpacing.xxl),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
