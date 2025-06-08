import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Detectar si hay poco espacio disponible
        final isCompactMode = constraints.maxHeight < 120;
        final screenWidth = ResponsiveHelper.getScreenWidth(context);

        return Padding(
          padding: ResponsiveHelper.getHorizontalPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logos institucionales - ADAPTABLES
              if (!isCompactMode) ...[
                _buildLogosSection(context, screenWidth),
                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
              ],

              // Texto legal - SIEMPRE VISIBLE pero adaptable
              _buildLegalText(context, screenWidth, isCompactMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogosSection(BuildContext context, double screenWidth) {
    // Calcular tamaño de logos basado en pantalla
    final logoWidth = ResponsiveHelper.getFooterLogoWidth(context);
    final logoHeight = logoWidth * 0.6;

    // En pantallas muy pequeñas, mostrar logos en 2 filas
    final isVerySmallScreen = screenWidth < 400;

    if (isVerySmallScreen) {
      return Column(
        children: [
          // Primera fila - 2 logos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLogo(
                context,
                'assets/images/xunta_de_galicia.png',
                'XUNTA\nDE GALICIA',
                Colors.blue,
                logoWidth * 1.2,
                logoHeight * 1.2,
              ),
              _buildLogo(
                context,
                'assets/images/fondos_europeos.png',
                'FONDOS\nEUROPEOS',
                Colors.blue,
                logoWidth * 1.2,
                logoHeight * 1.2,
              ),
            ],
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),
          // Segunda fila - 2 logos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLogo(
                context,
                'assets/images/Logotipo_del_Plan_de_Recuperacion.png',
                'PLAN DE\nRECUPERACIÓN',
                Colors.orange,
                logoWidth * 1.2,
                logoHeight * 1.2,
              ),
              _buildLogo(
                context,
                'assets/images/deputacion_da_coruna.png',
                'DEPUTACIÓN\nDA CORUÑA',
                Colors.indigo,
                logoWidth * 1.2,
                logoHeight * 1.2,
              ),
            ],
          ),
        ],
      );
    }

    // Pantallas normales - 4 logos en fila
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLogo(
          context,
          'assets/images/xunta_de_galicia.png',
          'XUNTA\nDE GALICIA',
          Colors.blue,
          logoWidth,
          logoHeight,
        ),
        _buildLogo(
          context,
          'assets/images/fondos_europeos.png',
          'FONDOS\nEUROPEOS',
          Colors.blue,
          logoWidth,
          logoHeight,
        ),
        _buildLogo(
          context,
          'assets/images/Logotipo_del_Plan_de_Recuperacion.png',
          'PLAN DE\nRECUPERACIÓN',
          Colors.orange,
          logoWidth,
          logoHeight,
        ),
        _buildLogo(
          context,
          'assets/images/deputacion_da_coruna.png',
          'DEPUTACIÓN\nDA CORUÑA',
          Colors.indigo,
          logoWidth,
          logoHeight,
        ),
      ],
    );
  }

  Widget _buildLogo(
    BuildContext context,
    String assetPath,
    String fallbackText,
    Color fallbackColor,
    double width,
    double height,
  ) {
    return Flexible(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 4 : 8),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: fallbackColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getCardBorderRadius(context) * 0.5,
                ),
              ),
              child: Center(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegalText(
    BuildContext context,
    double screenWidth,
    bool isCompactMode,
  ) {
    // Texto adaptable según el espacio disponible
    String text;
    if (isCompactMode) {
      // Versión muy corta para espacios mínimos
      text = 'Subvencións Programa modernización comercio - NextGenerationEU';
    } else if (screenWidth < 500) {
      // Versión corta para móviles
      text =
          'Subvencións para o Programa de modernización do comercio:\n'
          'NextGenerationEU (CO300G)';
    } else {
      // Versión completa para pantallas normales
      text =
          'Subvencións para o Programa de modernización do comercio:\n'
          'FondoTecnolóxico, no marco do Plan de recuperación, transformación e resiliencia '
          'financiado pola Unión Europea-NextGenerationEU (CO300G)';
    }

    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth - 40),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveHelper.getFooterTextSize(context),
          color: Colors.grey,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        maxLines: isCompactMode ? 2 : null,
        overflow: isCompactMode ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
