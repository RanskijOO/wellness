import 'package:flutter/material.dart';

class AloeColors {
  const AloeColors._();

  static const Color forest = Color(0xFF183A31);
  static const Color moss = Color(0xFF355B4E);
  static const Color aloe = Color(0xFF6D9575);
  static const Color sage = Color(0xFFA7C2A6);
  static const Color dew = Color(0xFFE7F0E8);
  static const Color mist = Color(0xFFF5F7F3);
  static const Color cloud = Color(0xFFFBFCF9);
  static const Color sand = Color(0xFFF0E7DB);
  static const Color clay = Color(0xFFC18B61);
  static const Color ink = Color(0xFF18251F);
  static const Color inkSoft = Color(0xFF52645C);
  static const Color success = Color(0xFF2C7A5A);
  static const Color warning = Color(0xFFBE8642);
  static const Color danger = Color(0xFF9C5A53);

  static const Color darkSurface = Color(0xFF0C1512);
  static const Color darkMuted = Color(0xFF14211C);
  static const Color darkCard = Color(0xFF1A2C24);
  static const Color darkElevated = Color(0xFF23372E);
}

class AloeSpacing {
  const AloeSpacing._();

  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

class AloeRadii {
  const AloeRadii._();

  static const BorderRadius sm = BorderRadius.all(Radius.circular(16));
  static const BorderRadius md = BorderRadius.all(Radius.circular(24));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(32));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AloeShadows {
  const AloeShadows._();

  static List<BoxShadow> soft(bool dark) => <BoxShadow>[
    BoxShadow(
      color: dark
          ? Colors.black.withValues(alpha: 0.22)
          : AloeColors.forest.withValues(alpha: 0.05),
      blurRadius: dark ? 18 : 28,
      offset: Offset(0, dark ? 10 : 14),
    ),
  ];

  static List<BoxShadow> elevated(bool dark) => <BoxShadow>[
    BoxShadow(
      color: dark
          ? Colors.black.withValues(alpha: 0.28)
          : AloeColors.forest.withValues(alpha: 0.10),
      blurRadius: dark ? 22 : 36,
      offset: Offset(0, dark ? 12 : 18),
    ),
  ];
}
