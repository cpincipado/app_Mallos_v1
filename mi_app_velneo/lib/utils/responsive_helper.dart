import 'package:flutter/material.dart';

// Enum para tamaños de espaciado
enum SpacingSize { xs, small, medium, large, xl, xxl }

class ResponsiveHelper {
  // ✅ BREAKPOINTS CON LÍMITE MÁXIMO
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double maxBreakpoint = 1200; // ✅ DESPUÉS DE ESTO NO CRECE MÁS

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

  // ✅ DETECTAR TIPO DE DISPOSITIVO CON LÍMITE
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    double width = getScreenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    double width = getScreenWidth(context);
    return width >= tabletBreakpoint;
  }

  // ✅ NUEVO: Detectar si es pantalla muy grande (para limitar)
  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) > maxBreakpoint;
  }

  // ================================
  // ✅ ESPACIADOS CON LÍMITES MÁXIMOS
  // ================================

  static double getVerticalSpacing(BuildContext context, SpacingSize size) {
    final multiplier = _getSpacingMultiplier(size);

    // ✅ NO CRECE MÁS DESPUÉS DE 1200px
    if (isLargeScreen(context)) return 8.0 * multiplier; // MÁXIMO
    if (isDesktop(context)) return 8.0 * multiplier;
    if (isTablet(context)) return 6.0 * multiplier;
    return 4.0 * multiplier; // Mobile
  }

  static double getSectionSpacing(BuildContext context) {
    return getVerticalSpacing(context, SpacingSize.xl);
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
  // ✅ PADDING CON LÍMITES MÁXIMOS
  // ================================

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isLargeScreen(context))
      return const EdgeInsets.symmetric(horizontal: 40); // MÁXIMO
    if (isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 40);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 30);
    return const EdgeInsets.symmetric(horizontal: 20); // Mobile
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    if (isLargeScreen(context)) return const EdgeInsets.all(24); // MÁXIMO
    if (isDesktop(context)) return const EdgeInsets.all(24);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(16); // Mobile
  }

  static EdgeInsets getFormPadding(BuildContext context) {
    if (isLargeScreen(context)) return const EdgeInsets.all(32); // MÁXIMO
    if (isDesktop(context)) return const EdgeInsets.all(32);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(20); // Mobile
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalPadding(context).horizontal / 2,
      vertical: getVerticalSpacing(context, SpacingSize.medium),
    );
  }

  // ================================
  // ✅ TYPOGRAPHY CON LÍMITES MÁXIMOS ABSOLUTOS
  // ================================

  static double getTitleFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 32; // MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 28;
    return 24; // Mobile
  }

  static double getSubtitleFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 24; // MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 22;
    return 20; // Mobile
  }

  static double getHeadingFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 20; // MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 20;
    if (isTablet(context)) return 18;
    return 16; // Mobile
  }

  static double getBodyFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 16; // ✅ MÁXIMO ABSOLUTO - CRÍTICO
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 15;
    return 14; // Mobile
  }

  static double getCaptionFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 14; // MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 14;
    if (isTablet(context)) return 13;
    return 12; // Mobile
  }

  static double getSmallFontSize(BuildContext context) {
    if (isLargeScreen(context)) return 12; // MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 12;
    if (isTablet(context)) return 11;
    return 10; // Mobile
  }

  // ================================
  // ✅ ALTURAS Y TAMAÑOS CON LÍMITES MÁXIMOS CRÍTICOS
  // ================================

  static double getButtonHeight(BuildContext context) {
    if (isLargeScreen(context)) return 56; // ✅ MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 56;
    if (isTablet(context)) return 52;
    return 48; // Mobile
  }

  static double getContainerMinHeight(BuildContext context) {
    if (isLargeScreen(context)) return 200; // ✅ MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 200;
    if (isTablet(context)) return 180;
    return 160; // Mobile
  }

  static double getCardElevation(BuildContext context) {
    if (isLargeScreen(context)) return 8; // MÁXIMO
    if (isDesktop(context)) return 8;
    if (isTablet(context)) return 6;
    return 4; // Mobile
  }

  static double getCardBorderRadius(BuildContext context) {
    if (isLargeScreen(context)) return 16; // MÁXIMO
    if (isDesktop(context)) return 16;
    if (isTablet(context)) return 14;
    return 12; // Mobile
  }

  static double getButtonBorderRadius(BuildContext context) {
    if (isLargeScreen(context)) return 12; // MÁXIMO
    if (isDesktop(context)) return 12;
    if (isTablet(context)) return 10;
    return 8; // Mobile
  }

  // ================================
  // ✅ TAMAÑOS ESPECÍFICOS CON LÍMITES MÁXIMOS CRÍTICOS
  // ================================

  static double getAppBarLogoHeight(BuildContext context) {
    if (isLargeScreen(context)) return 65; // MÁXIMO
    if (isDesktop(context)) return 65;
    if (isTablet(context)) return 55;
    return 45; // Mobile
  }

  static double getSplashLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    if (isLargeScreen(context)) return screenWidth * 0.4; // MÁXIMO
    if (isDesktop(context)) return screenWidth * 0.4;
    if (isTablet(context)) return screenWidth * 0.5;
    return screenWidth * 0.6; // Mobile
  }

  static double getFooterLogoWidth(BuildContext context) {
    double screenWidth = getScreenWidth(context);
    return (screenWidth - 60) / 4; // 4 logos con espaciado
  }

  static double getFooterTextSize(BuildContext context) {
    return getCaptionFontSize(context);
  }

  // ✅ CRÍTICO: Grid columns siempre 3
  static int getGridColumns(BuildContext context) {
    return 3; // SIEMPRE 3 COLUMNAS
  }

  // ✅ CRÍTICO: Tamaños de menú con límites máximos absolutos
  static double getMenuButtonIconSize(BuildContext context) {
    if (isLargeScreen(context)) return 40; // ✅ MÁXIMO ABSOLUTO
    if (isDesktop(context)) return 40;
    if (isTablet(context)) return 36;
    return 32; // Mobile
  }

  static double getMenuButtonTitleSize(BuildContext context) {
    return getBodyFontSize(context); // Usa el sistema limitado
  }

  static double getMenuButtonSubtitleSize(BuildContext context) {
    return getCaptionFontSize(context); // Usa el sistema limitado
  }

  // ================================
  // MÉTODOS HELPER PRIVADOS
  // ================================

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

  static Widget verticalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(height: getVerticalSpacing(context, size));
  }

  static Widget horizontalSpace(BuildContext context, SpacingSize size) {
    return SizedBox(width: getVerticalSpacing(context, size));
  }

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
