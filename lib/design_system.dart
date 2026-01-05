import 'package:flutter/material.dart';
import 'dart:ui';

class AppColors {
  static const Color primary = Color(00163359); // 00A3FF but fixed
  static const Color electricBlue = Color(0xFF00A3FF);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color vibrantRed = Color(0xFFFF5252);
  static const Color gold = Color(0xFFFFD700);
  
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0x1A64748B); // semi-transparent
  static const Color cardBg = Color(0x330F172A);
}

class AppDesign {
  static BoxDecoration glassDecoration({
    double blur = 10.0,
    double opacity = 0.1,
    Color color = Colors.white,
    double borderRadius = 16.0,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: hasBorder ? Border.all(color: color.withOpacity(0.1)) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static Widget glassMorphism({
    required Widget child,
    double blur = 15.0,
    double opacity = 0.1,
    Color color = Colors.white,
    double borderRadius = 20.0,
    EdgeInsets? padding,
    bool hasBorder = true,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: glassDecoration(
            blur: blur,
            opacity: opacity,
            color: color,
            borderRadius: borderRadius,
            hasBorder: hasBorder,
          ),
          child: child,
        ),
      ),
    );
  }

  static LinearGradient meshGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.background,
        AppColors.primary.withOpacity(0.3),
        AppColors.background,
      ],
    );
  }

  static Future<T?> glassDialog<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: AppDesign.glassMorphism(
                padding: const EdgeInsets.all(24),
                borderRadius: 24,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(title, style: AppTypography.h2),
                        const SizedBox(height: 16),
                      ],
                      content,
                      if (actions != null) ...[
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppTypography {
  static TextStyle h1 = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle body = const TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );

  static TextStyle caption = const TextStyle(
    fontSize: 12,
    color: Colors.white54,
  );
}
