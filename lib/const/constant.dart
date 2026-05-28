import 'package:flutter/material.dart';

class AppColors {

  // ====================
  // PRIMARY COLORS
  // ====================

  static const primary =
  Color(0xFF2563EB);

  static const primaryDark =
  Color(0xFF1E40AF);

  // ====================
  // BACKGROUND COLORS
  // ====================

  static const background =
  Color(0xFFF9FAFB);

  static const white =
      Colors.white;

  // ====================
  // TEXT COLORS
  // ====================

  static const textPrimary =
  Color(0xFF111827);

  static const textSecondary =
  Color(0xFF6B7280);

  // ====================
  // STATUS COLORS
  // ====================

  static const success =
  Color(0xFF22C55E);

  static const error =
  Color(0xFFEF4444);

  // ====================
  // MENU EFFECT COLORS
  // ====================

  static const menuHighlight =
  Color(0x1A2563EB);

  static const menuSplash =
  Color(0x332563EB);

  static const menuHover =
  Color(0x0D2563EB);

  // ====================
  // PRIMARY GRADIENT
  // ====================

  static const primaryGradient =
  LinearGradient(

    colors: [
      Color(0xFF2563EB),
      Color(0xFF1E40AF),
    ],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/////////////////////////////////////////////////////////////

class AppSpacing {

  // ====================
  // COMMON PADDING
  // ====================

  static const padding =
  EdgeInsets.all(24);

  // ====================
  // VERTICAL SPACING
  // ====================

  static const small = 12.0;
  static const medium = 20.0;
  static const large = 24.0;
}

/////////////////////////////////////////////////////////////

class AppRadius {

  // ====================
  // COMMON CARD RADIUS
  // ====================

  static const card =
  BorderRadius.all(
    Radius.circular(16),
  );
}

/////////////////////////////////////////////////////////////

class AppShadow {

  // ====================
  // DEFAULT CARD SHADOW
  // ====================

  static List<BoxShadow> cardShadow = [

    BoxShadow(

      color:
      Colors.black.withOpacity(0.05),

      blurRadius: 6,

      offset: const Offset(0, 2),
    ),
  ];

  // ====================
  // STRONG SHADOW
  // ====================

  static List<BoxShadow> strongShadow = [

    BoxShadow(

      color:
      Colors.black.withOpacity(0.15),

      blurRadius: 12,

      offset: const Offset(0, 5),
    ),
  ];
}