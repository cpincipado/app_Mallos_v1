import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

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
              // Logos institucionales - SIEMPRE EN 1 FILA
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
    // ✅ CÁLCULO ADAPTATIVO para 1 fila
    final logoWidth = ResponsiveHelper.getFooterLogoWidth(context);
    final logoHeight = logoWidth * 0.5; // Más ancho, menos alto

    // ✅ SIEMPRE 4 logos en 1 fila - ADAPTATIVO
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoWidth,
                  maxHeight: logoHeight,
                ),
                child: InstitutionalLogo(
                  assetPath: 'assets/images/xunta_de_galicia.png',
                  fallbackText: 'XUNTA\nDE GALICIA',
                  fallbackColor: Colors.blue,
                  width: logoWidth,
                  height: logoHeight,
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoWidth,
                  maxHeight: logoHeight,
                ),
                child: InstitutionalLogo(
                  assetPath: 'assets/images/fondos_europeos.png',
                  fallbackText: 'FONDOS\nEUROPEOS',
                  fallbackColor: Colors.blue,
                  width: logoWidth,
                  height: logoHeight,
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoWidth,
                  maxHeight: logoHeight,
                ),
                child: InstitutionalLogo(
                  assetPath:
                      'assets/images/Logotipo_del_Plan_de_Recuperacion.png',
                  fallbackText: 'PLAN DE\nRECUPERACIÓN',
                  fallbackColor: Colors.orange,
                  width: logoWidth,
                  height: logoHeight,
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoWidth,
                  maxHeight: logoHeight,
                ),
                child: InstitutionalLogo(
                  assetPath: 'assets/images/deputacion_da_coruna.png',
                  fallbackText: 'DEPUTACIÓN\nDA CORUÑA',
                  fallbackColor: Colors.indigo,
                  width: logoWidth,
                  height: logoHeight,
                ),
              ),
            ),
          ],
        );
      },
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
