import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/app_tokens.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonStyle style = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      backgroundColor: AloeColors.forest,
      foregroundColor: Colors.white,
      elevation: onPressed == null ? 0 : 2,
      shadowColor: AloeColors.forest.withValues(alpha: 0.24),
      textStyle: theme.textTheme.labelLarge,
      minimumSize: const Size.fromHeight(58),
      shape: RoundedRectangleBorder(borderRadius: AloeRadii.md),
    );
    final Widget labelWidget = Text(label, textAlign: TextAlign.center);
    final Widget child = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 58),
      child: FilledButton(
        onPressed: onPressed,
        style: style,
        child: icon == null
            ? labelWidget
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: 18),
                  const SizedBox(width: AloeSpacing.sm),
                  Flexible(child: labelWidget),
                ],
              ),
      ),
    );

    if (!expand) {
      return child;
    }
    return SizedBox(width: double.infinity, child: child);
  }
}

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonStyle style = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      backgroundColor: theme.brightness == Brightness.dark
          ? AloeColors.darkMuted.withValues(alpha: 0.92)
          : Colors.white.withValues(alpha: 0.74),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
      ),
      textStyle: theme.textTheme.labelLarge,
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(borderRadius: AloeRadii.md),
    );
    final Widget labelWidget = Text(label, textAlign: TextAlign.center);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: icon == null
            ? labelWidget
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: 18),
                  const SizedBox(width: AloeSpacing.sm),
                  Flexible(child: labelWidget),
                ],
              ),
      ),
    );
  }
}

class SectionSurface extends StatelessWidget {
  const SectionSurface({
    required this.child,
    this.padding = const EdgeInsets.all(AloeSpacing.xl),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = dark
        ? AloeColors.darkCard.withValues(alpha: 0.98)
        : Theme.of(context).cardTheme.color ?? Colors.white;
    final Widget content = Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: AloeRadii.lg,
          gradient: LinearGradient(
            colors: dark
                ? <Color>[
                    baseColor,
                    AloeColors.darkElevated.withValues(alpha: 0.94),
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
                ? Colors.white.withValues(alpha: 0.06)
                : AloeColors.forest.withValues(alpha: 0.06),
          ),
          boxShadow: AloeShadows.soft(dark),
        ),
        child: ClipRRect(
          borderRadius: AloeRadii.lg,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -30,
                right: -16,
                child: _AmbientOrb(
                  size: 116,
                  color: dark
                      ? AloeColors.sage.withValues(alpha: 0.10)
                      : AloeColors.aloe.withValues(alpha: 0.12),
                ),
              ),
              Positioned(
                bottom: -42,
                left: -12,
                child: _AmbientOrb(
                  size: 92,
                  color: dark
                      ? AloeColors.clay.withValues(alpha: 0.07)
                      : AloeColors.sand.withValues(alpha: 0.32),
                ),
              ),
              Padding(padding: padding, child: child),
            ],
          ),
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }
    return InkWell(borderRadius: AloeRadii.lg, onTap: onTap, child: content);
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (eyebrow != null) ...<Widget>[
                Text(
                  eyebrow!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.2,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(height: AloeSpacing.sm),
              ],
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: AloeSpacing.sm),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: AloeRadii.md,
        gradient: LinearGradient(
          colors: dark
              ? <Color>[
                  AloeColors.darkElevated.withValues(alpha: 0.92),
                  AloeColors.darkCard.withValues(alpha: 0.96),
                ]
              : <Color>[
                  Colors.white.withValues(alpha: 0.86),
                  AloeColors.dew.withValues(alpha: 0.76),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: dark
              ? Colors.white.withValues(alpha: 0.06)
              : scheme.primary.withValues(alpha: 0.08),
        ),
        boxShadow: AloeShadows.soft(dark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AloeIconBadge(icon: icon, size: 38),
          const SizedBox(width: AloeSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(letterSpacing: 0.2),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class WaterRing extends StatelessWidget {
  const WaterRing({
    required this.progress,
    required this.valueLabel,
    required this.caption,
    this.size = 158,
    super.key,
  });

  final double progress;
  final String valueLabel;
  final String caption;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double innerSize = size * 0.684;
    final bool compact = size < 150;
    final TextStyle? valueStyle = (compact
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.titleLarge)
        ?.copyWith(fontWeight: FontWeight.w800);
    final TextStyle? captionStyle = compact
        ? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)
        : Theme.of(context).textTheme.bodySmall;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size.square(size),
            painter: _WaterRingPainter(
              progress: progress.clamp(0, 1),
              foreground: Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? <Color>[
                        AloeColors.darkCard,
                        AloeColors.darkElevated.withValues(alpha: 0.96),
                      ]
                    : <Color>[
                        Colors.white.withValues(alpha: 0.95),
                        AloeColors.dew.withValues(alpha: 0.74),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.10),
              ),
              boxShadow: AloeShadows.soft(
                Theme.of(context).brightness == Brightness.dark,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    valueLabel,
                    style: valueStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: compact ? 2 : AloeSpacing.xs),
                  Text(
                    caption,
                    style: captionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AloePageBackground extends StatelessWidget {
  const AloePageBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? <Color>[
                  AloeColors.darkSurface,
                  AloeColors.darkMuted,
                  AloeColors.darkSurface,
                ]
              : <Color>[
                  AloeColors.mist,
                  AloeColors.cloud,
                  AloeColors.sand.withValues(alpha: 0.45),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -60,
            left: -30,
            child: _AmbientOrb(
              size: 210,
              color: dark
                  ? AloeColors.sage.withValues(alpha: 0.08)
                  : AloeColors.aloe.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 160,
            right: -48,
            child: _AmbientOrb(
              size: 196,
              color: dark
                  ? AloeColors.clay.withValues(alpha: 0.06)
                  : AloeColors.sand.withValues(alpha: 0.45),
            ),
          ),
          Positioned(
            bottom: -84,
            left: 40,
            child: _AmbientOrb(
              size: 188,
              color: dark
                  ? AloeColors.aloe.withValues(alpha: 0.06)
                  : AloeColors.dew.withValues(alpha: 0.72),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class AloeIconBadge extends StatelessWidget {
  const AloeIconBadge({
    required this.icon,
    this.size = 44,
    this.circular = false,
    super.key,
  });

  final IconData icon;
  final double size;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : AloeRadii.md,
        gradient: LinearGradient(
          colors: dark
              ? <Color>[
                  primary.withValues(alpha: 0.22),
                  AloeColors.darkElevated.withValues(alpha: 0.92),
                ]
              : <Color>[
                  primary.withValues(alpha: 0.14),
                  Colors.white.withValues(alpha: 0.92),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: dark
              ? Colors.white.withValues(alpha: 0.08)
              : primary.withValues(alpha: 0.12),
        ),
        boxShadow: AloeShadows.soft(dark),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.42, color: primary),
    );
  }
}

class ActionTileButton extends StatelessWidget {
  const ActionTileButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: AloeRadii.md,
      onTap: onTap,
      child: Ink(
        width: 156,
        padding: const EdgeInsets.all(AloeSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AloeRadii.md,
          gradient: LinearGradient(
            colors: dark
                ? <Color>[
                    AloeColors.darkElevated.withValues(alpha: 0.96),
                    AloeColors.darkCard,
                  ]
                : <Color>[
                    Colors.white.withValues(alpha: 0.90),
                    AloeColors.dew.withValues(alpha: 0.72),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.06)
                : AloeColors.forest.withValues(alpha: 0.08),
          ),
          boxShadow: AloeShadows.soft(dark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AloeIconBadge(icon: icon, size: 42),
            const SizedBox(height: AloeSpacing.md),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: AloeSpacing.xs),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    required this.body,
    this.icon = Icons.spa_outlined,
    super.key,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AloeSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AloeIconBadge(icon: icon, size: 78, circular: true),
              const SizedBox(height: AloeSpacing.lg),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AloeSpacing.sm),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onRetry,
    super.key,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AloeSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[
                      Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.18),
                      Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: AloeSpacing.lg),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AloeSpacing.sm),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (actionLabel != null && onRetry != null) ...<Widget>[
                const SizedBox(height: AloeSpacing.xl),
                AppSecondaryButton(label: actionLabel!, onPressed: onRetry),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingStateView extends StatelessWidget {
  const LoadingStateView({this.label = 'Завантажуємо дані...', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AloeColors.darkCard
                  : Colors.white.withValues(alpha: 0.9),
              boxShadow: AloeShadows.soft(
                Theme.of(context).brightness == Brightness.dark,
              ),
            ),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
          const SizedBox(height: AloeSpacing.lg),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class GradientHero extends StatelessWidget {
  const GradientHero({
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double textScale = MediaQuery.textScalerOf(context).scale(1);
        final bool compact =
            constraints.maxWidth < 420 || textScale > 1.05;
        final EdgeInsetsGeometry padding = EdgeInsets.all(
          compact ? AloeSpacing.xl : AloeSpacing.xxl,
        );
        final TextStyle? titleStyle = compact
            ? Theme.of(context).textTheme.headlineMedium
            : Theme.of(context).textTheme.headlineLarge;
        final Widget textColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (eyebrow != null) ...<Widget>[
              Text(
                eyebrow!.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.4,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(height: AloeSpacing.sm),
            ],
            Text(title, style: titleStyle),
            const SizedBox(height: AloeSpacing.md),
            Text(
              subtitle,
              style: compact
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        );

        return Container(
          padding: padding,
          constraints: BoxConstraints(minHeight: compact ? 0 : 188),
          decoration: BoxDecoration(
            borderRadius: AloeRadii.lg,
            gradient: LinearGradient(
              colors: dark
                  ? <Color>[
                      AloeColors.darkElevated.withValues(alpha: 0.96),
                      AloeColors.darkCard,
                      AloeColors.forest.withValues(alpha: 0.72),
                    ]
                  : <Color>[
                      Colors.white.withValues(alpha: 0.92),
                      AloeColors.dew.withValues(alpha: 0.96),
                      AloeColors.sand.withValues(alpha: 0.88),
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
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  top: -28,
                  left: -18,
                  child: _AmbientOrb(
                    size: 136,
                    color: dark
                        ? AloeColors.sage.withValues(alpha: 0.12)
                        : AloeColors.aloe.withValues(alpha: 0.14),
                  ),
                ),
                Positioned(
                  bottom: -52,
                  right: trailing == null ? -14 : 52,
                  child: _AmbientOrb(
                    size: 144,
                    color: dark
                        ? AloeColors.clay.withValues(alpha: 0.08)
                        : AloeColors.sand.withValues(alpha: 0.56),
                  ),
                ),
                if (compact || trailing == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (trailing != null) ...<Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                        const SizedBox(height: AloeSpacing.lg),
                      ],
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 2,
                          top: 4,
                          bottom: 4,
                        ),
                        child: textColumn,
                      ),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 2,
                            top: 4,
                            bottom: 4,
                          ),
                          child: textColumn,
                        ),
                      ),
                      const SizedBox(width: AloeSpacing.lg),
                      trailing!,
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

IconData resolveIcon(String iconKey) => switch (iconKey) {
  'water_drop' => Icons.water_drop_rounded,
  'sunny' => Icons.sunny,
  'bolt' => Icons.bolt_rounded,
  'monitor_weight' => Icons.monitor_weight_outlined,
  'check_circle' => Icons.check_circle_outline_rounded,
  'spa' => Icons.spa_outlined,
  'nutrition' => Icons.breakfast_dining_outlined,
  'hive' => Icons.hive_outlined,
  'self_improvement' => Icons.self_improvement,
  'inventory_2' => Icons.inventory_2_outlined,
  'aloe' => Icons.eco_outlined,
  'berry' => Icons.local_drink_outlined,
  'shake' => Icons.blender_outlined,
  'fiber' => Icons.grain_outlined,
  'bee' => Icons.hive_outlined,
  'propolis' => Icons.energy_savings_leaf_outlined,
  'cream' => Icons.water_drop_outlined,
  'gelly' => Icons.bubble_chart_outlined,
  'body' => Icons.shower_outlined,
  'smile' => Icons.sentiment_satisfied_alt_outlined,
  'pack' => Icons.inventory_2_outlined,
  'glow' => Icons.auto_awesome_outlined,
  'hair' => Icons.content_cut_rounded,
  'home' => Icons.cleaning_services_outlined,
  'fragrance' => Icons.local_florist_outlined,
  _ => Icons.eco_outlined,
};

String formatWellnessTag(String tag) => switch (tag) {
  'hydration' => 'Гідратація',
  'aloe' => 'Aloe',
  'daily-routine' => 'Щоденний ритм',
  'nutrition' => 'Харчова підтримка',
  'energy' => 'Енергія',
  'focus' => 'Фокус',
  'healthy-routine' => 'Здорова рутина',
  'balance' => 'Баланс',
  'beauty' => 'Краса',
  'skin' => 'Шкіра',
  'bee' => 'Bee-продукти',
  'combo' => 'Комбо-набір',
  'self-care' => 'Self-care',
  _ => tag,
};

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _WaterRingPainter extends CustomPainter {
  _WaterRingPainter({required this.progress, required this.foreground});

  final double progress;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = math.min(size.width, size.height) / 2 - 14;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..color = foreground.withValues(alpha: 0.14)
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..shader = SweepGradient(
        colors: <Color>[
          foreground.withValues(alpha: 0.4),
          foreground,
          AloeColors.clay,
        ],
      ).createShader(rect)
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    final double angle = (-math.pi / 2) + (2 * math.pi * progress);
    final Offset thumbCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    final Paint thumbPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95);
    final Paint glowPaint = Paint()
      ..color = foreground.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(thumbCenter, 10, glowPaint);
    canvas.drawCircle(thumbCenter, 6, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _WaterRingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        foreground != oldDelegate.foreground;
  }
}
