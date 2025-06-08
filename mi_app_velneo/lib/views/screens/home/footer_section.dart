import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Logos institucionales - SIEMPRE EN 1 FILA
              _buildLogosRow(context, constraints.maxWidth),

              ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

              // ✅ Texto legal responsive
              _buildLegalText(context, constraints.maxWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogosRow(BuildContext context, double screenWidth) {
    // ✅ CÁLCULO AUTOMÁTICO basado en el ancho disponible
    final horizontalPadding = ResponsiveHelper.getHorizontalPadding(
      context,
    ).horizontal;
    final availableWidth = screenWidth - horizontalPadding;

    // ✅ Espaciado entre logos (responsive)
    double logoSpacing;
    if (ResponsiveHelper.isDesktop(context)) {
      logoSpacing = 24.0;
    } else if (ResponsiveHelper.isTablet(context)) {
      logoSpacing = 20.0;
    } else {
      logoSpacing = 16.0;
    }

    // ✅ CÁLCULO AUTOMÁTICO del tamaño de logo
    // Ancho disponible menos 3 espacios entre 4 logos, dividido entre 4
    final totalSpacing = logoSpacing * 3;
    final logoWidth = (availableWidth - totalSpacing) / 4;

    // ✅ Tamaño mínimo y máximo para evitar extremos
    const minLogoSize = 40.0;
    final maxLogoSize = ResponsiveHelper.isDesktop(context)
        ? 120.0
        : ResponsiveHelper.isTablet(context)
        ? 100.0
        : 80.0;

    final finalLogoWidth = logoWidth.clamp(minLogoSize, maxLogoSize);
    final logoHeight = finalLogoWidth * 0.7; // Aspect ratio controlado

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // ✅ Centrado para mejor distribución
        children: [
          // ✅ Logos con tamaño calculado automáticamente
          _buildLogo(
            context,
            'assets/images/xunta_de_galicia.png',
            'XUNTA\nDE GALICIA',
            Colors.blue,
            finalLogoWidth,
            logoHeight,
          ),
          SizedBox(width: logoSpacing),
          _buildLogo(
            context,
            'assets/images/fondos_europeos.png',
            'FONDOS\nEUROPEOS',
            Colors.blue,
            finalLogoWidth,
            logoHeight,
          ),
          SizedBox(width: logoSpacing),
          _buildLogo(
            context,
            'assets/images/Logotipo_del_Plan_de_Recuperacion.png',
            'PLAN DE\nRECUPERACIÓN',
            Colors.orange,
            finalLogoWidth,
            logoHeight,
          ),
          SizedBox(width: logoSpacing),
          _buildLogo(
            context,
            'assets/images/deputacion_da_coruna.png',
            'DEPUTACIÓN\nDA CORUÑA',
            Colors.indigo,
            finalLogoWidth,
            logoHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(
    BuildContext context,
    String assetPath,
    String fallbackText,
    Color fallbackColor,
    double maxWidth,
    double maxHeight,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      child: Container(
        width: maxWidth,
        height: maxHeight,
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 4 : 6),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // ✅ Fallback mejorado para logos
            return Container(
              decoration: BoxDecoration(
                color: fallbackColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    fallbackText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.getSmallFontSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegalText(BuildContext context, double screenWidth) {
    // ✅ Texto adaptable según el dispositivo
    String text;
    int maxLines;

    if (ResponsiveHelper.isDesktop(context)) {
      // Versión completa para desktop
      text =
          'Subvencións para o Programa de modernización do comercio: '
          'FondoTecnolóxico, no marco do Plan de recuperación, transformación e resiliencia '
          'financiado pola Unión Europea-NextGenerationEU (CO300G)';
      maxLines = 3;
    } else if (ResponsiveHelper.isTablet(context)) {
      // Versión intermedia para tablet
      text =
          'Subvencións para o Programa de modernización do comercio:\n'
          'FondoTecnolóxico - NextGenerationEU (CO300G)';
      maxLines = 3;
    } else {
      // Versión corta para móvil
      text =
          'Subvencións Programa modernización comercio\n'
          'NextGenerationEU (CO300G)';
      maxLines = 2;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveHelper.getSmallFontSize(context),
          color: Colors.grey,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
