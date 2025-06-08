import 'package:flutter/material.dart';

// Enum para tamaños de espaciado
enum SpacingSize { xs, small, medium, large, xl }

class ResponsiveHelper {
  // Breakpoints simplificados
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Obtener tamaño de pantalla
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Detectar tipo de dispositivo - SOLO 3 TIPOS
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
  // ESPACIADOS VERTICALES SIMPLIFICADOS
  // ================================

  static double getVerticalSpacing(BuildContext context, SpacingSize size) {
    final multiplier = _getSpacingMultiplier(size);

    // Espaciados fijos para cada tipo
    if (isDesktop(context)) return 8.0 * multiplier;
    if (isTablet(context)) return 6.0 * multiplier;
    return 4.0 * multiplier; // Mobile
  }

  static double getSmallSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.small);
  }

  static double getMediumSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.medium);
  }

  static double getLargeSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.large);
  }

  // ================================
  // PADDING SIMPLIFICADO
  // ================================

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 32);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 16); // Mobile
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    if (isDesktop(context)) return const EdgeInsets.all(20);
    if (isTablet(context)) return const EdgeInsets.all(16);
    return const EdgeInsets.all(12); // Mobile
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalPadding(context).horizontal / 2,
      vertical: getMediumSpacing(context),
    );
  }

  // ================================
  // TYPOGRAPHY SIMPLIFICADA
  // ================================

  static double getTitleFontSize(BuildContext context) {
    if (isDesktop(context)) return 28;
    if (isTablet(context)) return 24;
    return 20; // Mobile
  }

  static double getSubtitleFontSize(BuildContext context) {
    if (isDesktop(context)) return 20;
    if (isTablet(context)) return 18;
    return 16; // Mobile
  }

  static double getHeadingFontSize(BuildContext context) {
    if (isDesktop(context)) return 18;
    if (isTablet(context)) return 16;
    return 14; // Mobile
  }

  static double getBodyFontSize(BuildContext context) {
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 15;
    return 14; // Mobile
  }

  static double getCaptionFontSize(BuildContext context) {
    if (isDesktop(context)) return 14;
    if (isTablet(context)) return 13;
    return 12; // Mobile
  }

  static double getSmallFontSize(BuildContext context) {
    if (isDesktop(context)) return 12;
    if (isTablet(context)) return 11;
    return 10; // Mobile
  }

  // ================================
  // TAMAÑOS DE COMPONENTES - FIJOS PARA EVITAR CRECIMIENTO EXCESIVO
  // ================================

  // Altura de botones - FIJA para evitar que crezcan demasiado
  static double getButtonHeight(BuildContext context) {
    return 48; // Altura fija para todos los dispositivos
  }

  // Altura mínima de contenedores
  static double getContainerMinHeight(BuildContext context) {
    if (isDesktop(context)) return 180;
    if (isTablet(context)) return 160;
    return 140; // Mobile
  }

  // Elevación y bordes
  static double getCardElevation(BuildContext context) {
    return 4; // Fijo
  }

  static double getCardBorderRadius(BuildContext context) {
    return 12; // Fijo
  }

  static double getButtonBorderRadius(BuildContext context) {
    return 8; // Fijo
  }

  // ================================
  // TAMAÑOS ESPECÍFICOS CONTROLADOS
  // ================================

  static double getAppBarLogoHeight(BuildContext context) {
    if (isDesktop(context)) return 50;
    if (isTablet(context)) return 45;
    return 40; // Mobile
  }

  static double getSplashLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    if (isDesktop(context)) return screenWidth * 0.3; // Más pequeño en desktop
    if (isTablet(context)) return screenWidth * 0.4;
    return screenWidth * 0.6; // Mobile
  }

  static double getFooterLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    return (screenWidth - 60) / 4; // 4 logos con espaciado
  }

  // TAMAÑOS DE ICONOS Y BOTONES DEL MENÚ - CONTROLADOS
  static double getMenuButtonIconSize(BuildContext context) {
    // Tamaño fijo para evitar iconos gigantes
    return 28; // Fijo para todos los dispositivos
  }

  static double getMenuButtonTitleSize(BuildContext context) {
    return getBodyFontSize(context);
  }

  static double getMenuButtonSubtitleSize(BuildContext context) {
    return getCaptionFontSize(context);
  }

  // Grid siempre 3 columnas
  static int getGridColumns(BuildContext context) {
    return 3;
  }

  // ================================
  // MÉTODOS HELPER PRIVADOS
  // ================================

  static double _getSpacingMultiplier(SpacingSize size) {
    switch (size) {
      case SpacingSize.xs:
        return 0.5;
      case SpacingSize.small:
        return 1.0;
      case SpacingSize.medium:
        return 2.0;
      case SpacingSize.large:
        return 3.0;
      case SpacingSize.xl:
        return 4.0;
    }
  }

  // ================================
  // WIDGETS HELPER
  // ================================

  static Widget verticalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(height: getVerticalSpacing(context, size));
  }

  static Widget horizontalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(width: getVerticalSpacing(context, size));
  }
}
