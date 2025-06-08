import 'package:flutter/material.dart';

// Enum para tamaños de espaciado
enum SpacingSize { xs, small, medium, large, xl, xxl }

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Obtener tamaño de pantalla
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Detectar tipo de dispositivo
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    double width = getScreenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= tabletBreakpoint;
  }

  // ================================
  // ESPACIADOS VERTICALES RESPONSIVOS
  // ================================

  /// Espaciado vertical responsivo basado en tamaño
  static double getVerticalSpacing(BuildContext context, SpacingSize size) {
    final multiplier = _getSpacingMultiplier(size);

    if (isDesktop(context)) return 8.0 * multiplier;
    if (isTablet(context)) return 6.0 * multiplier;
    return 4.0 * multiplier; // Mobile
  }

  /// Espaciado entre secciones principales
  static double getSectionSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.xl);
  }

  /// Espaciado pequeño entre elementos relacionados
  static double getSmallSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.small);
  }

  /// Espaciado medio (más común)
  static double getMediumSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.medium);
  }

  /// Espaciado grande entre grupos de elementos
  static double getLargeSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.large);
  }

  // ================================
  // PADDING Y MARGINS RESPONSIVOS
  // ================================

  /// Padding horizontal responsivo (ya existía, mantenido)
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 40);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 30);
    return const EdgeInsets.symmetric(horizontal: 20); // Mobile
  }

  /// Padding para tarjetas y contenedores
  static EdgeInsets getCardPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.all(24);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(16); // Mobile
  }

  /// Padding para formularios
  static EdgeInsets getFormPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.all(32);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(20); // Mobile
  }

  /// Padding para pantallas completas
  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalPadding(context).horizontal / 2,
      vertical: getVerticalSpacing(context, SpacingSize.medium),
    );
  }

  // ================================
  // SISTEMA DE TYPOGRAPHY RESPONSIVO
  // ================================

  /// Título principal (headings H1)
  static double getTitleFontSize(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 28;
    return 24; // Mobile
  }

  /// Subtítulo (headings H2)
  static double getSubtitleFontSize(BuildContext context) {
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 22;
    return 20; // Mobile
  }

  /// Texto de cabecera (headings H3)
  static double getHeadingFontSize(BuildContext context) {
    if (isDesktop(context)) return 20;
    if (isTablet(context)) return 18;
    return 16; // Mobile
  }

  /// Texto del cuerpo principal
  static double getBodyFontSize(BuildContext context) {
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 15;
    return 14; // Mobile
  }

  /// Texto pequeño (captions, hints)
  static double getCaptionFontSize(BuildContext context) {
    if (isDesktop(context)) return 14;
    if (isTablet(context)) return 13;
    return 12; // Mobile
  }

  /// Texto muy pequeño (footer, legal)
  static double getSmallFontSize(BuildContext context) {
    if (isDesktop(context)) return 12;
    if (isTablet(context)) return 11;
    return 10; // Mobile
  }

  // ================================
  // ALTURAS Y TAMAÑOS DE COMPONENTES
  // ================================

  /// Altura estándar de botones
  static double getButtonHeight(BuildContext context) {
    if (isDesktop(context)) return 56;
    if (isTablet(context)) return 52;
    return 48; // Mobile
  }

  /// Altura mínima de contenedores importantes
  static double getContainerMinHeight(BuildContext context) {
    if (isDesktop(context)) return 200;
    if (isTablet(context)) return 180;
    return 160; // Mobile
  }

  /// Elevación para tarjetas
  static double getCardElevation(BuildContext context) {
    if (isDesktop(context)) return 8;
    if (isTablet(context)) return 6;
    return 4; // Mobile
  }

  /// Radio de bordes para tarjetas
  static double getCardBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 14;
    return 12; // Mobile
  }

  /// Radio de bordes para botones
  static double getButtonBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 12;
    if (isTablet(context)) return 10;
    return 8; // Mobile
  }

  // ================================
  // TAMAÑOS ESPECÍFICOS (mantenidos del original)
  // ================================

  static double getAppBarLogoHeight(BuildContext context) {
    if (isDesktop(context)) return 65;
    if (isTablet(context)) return 55;
    return 45; // Mobile
  }

  static double getSplashLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    if (isDesktop(context)) return screenWidth * 0.4;
    if (isTablet(context)) return screenWidth * 0.5;
    return screenWidth * 0.6; // Mobile
  }

  // ================================
  // MÉTODOS CORREGIDOS - FOOTER SIEMPRE 1 FILA
  // ================================

  /// Footer logos SIEMPRE en 1 fila, adaptándose al tamaño de pantalla
  static double getFooterLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);

    // SIEMPRE 4 logos en 1 fila, pero con márgenes adaptativos
    if (isDesktop(context)) {
      return (screenWidth - 160) / 4; // Margen generoso
    }
    if (isTablet(context)) {
      return (screenWidth - 120) / 4; // Margen medio
    }

    // Mobile: margen muy ajustado para que quepan los 4
    return (screenWidth - 60) /
        4.2; // Divisor 4.2 para dar un poco más de espacio
  }

  /// Altura del MenuGrid MÁS ALTA para evitar solapamiento
  static double getMenuGridHeight(BuildContext context) {
    double baseHeight;

    if (isDesktop(context)) {
      baseHeight = 160; // MUY alto en desktop
    } else if (isTablet(context)) {
      baseHeight = 140; // MUY alto en tablet
    } else {
      baseHeight = 120; // MUY alto en móvil
    }

    // 2 filas + espaciado entre filas + PADDING INTERNO de cada botón
    final spacingBetweenRows = getMediumSpacing(context) * 2;
    final cardPaddingVertical = getCardPadding(context).vertical; // ¡NUEVO!
    final totalHeight =
        (baseHeight * 2) + spacingBetweenRows + cardPaddingVertical;

    return totalHeight;
  }

  /// Aspect ratio para que los botones no sean muy altos
  static double getMenuButtonAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.4; // Más anchos
    if (isTablet(context)) return 1.3;
    return 1.2; // Menos altos en móvil
  }

  static double getFooterTextSize(BuildContext context) {
    return getCaptionFontSize(context); // Usar el sistema de typography
  }

  /// Altura del footer para cálculos de posicionamiento absoluto
  static double getFooterHeight(BuildContext context) {
    // Altura de logos + texto + padding + espaciado
    final logoHeight = getFooterLogoWidth(context) * 0.6;
    final textHeight = getFooterTextSize(context) * 3; // ~3 líneas de texto
    final padding = getCardPadding(context).vertical;
    final spacing = getMediumSpacing(context);

    return logoHeight + textHeight + padding + spacing;
  }

  // Grid columns responsivo - MANTENER SIEMPRE 3 COLUMNAS
  static int getGridColumns(BuildContext context) {
    return 3; // Siempre 3 columnas para mantener el diseño 3x2
  }

  // Tamaños de iconos y textos para botones del menú
  static double getMenuButtonIconSize(BuildContext context) {
    if (isDesktop(context)) return 40;
    if (isTablet(context)) return 36;
    return 32; // Mobile
  }

  static double getMenuButtonTitleSize(BuildContext context) {
    return getBodyFontSize(context); // Usar sistema de typography
  }

  static double getMenuButtonSubtitleSize(BuildContext context) {
    return getCaptionFontSize(context); // Usar sistema de typography
  }

  // ================================
  // MÉTODOS HELPER PRIVADOS
  // ================================

  /// Obtiene el multiplicador para el espaciado basado en el tamaño
  static double _getSpacingMultiplier(SpacingSize size) {
    switch (size) {
      case SpacingSize.xs:
        return 0.5; // 2-4px
      case SpacingSize.small:
        return 1.0; // 4-8px
      case SpacingSize.medium:
        return 2.0; // 8-16px
      case SpacingSize.large:
        return 3.0; // 12-24px
      case SpacingSize.xl:
        return 4.0; // 16-32px
      case SpacingSize.xxl:
        return 6.0; // 24-48px
    }
  }

  // ================================
  // WIDGETS HELPER RESPONSIVOS
  // ================================

  /// SizedBox vertical responsivo
  static Widget verticalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(height: getVerticalSpacing(context, size));
  }

  /// SizedBox horizontal responsivo
  static Widget horizontalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(width: getVerticalSpacing(context, size));
  }

  /// Divider con espaciado responsivo
  static Widget sectionDivider(BuildContext context) {
    return Column(
      children: [
        verticalSpace(context, SpacingSize.large),
        const Divider(),
        verticalSpace(context, SpacingSize.large),
      ],
    );
  }
}
