import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: GestureDetector(
        onTap: () {
          // TODO: Navegar a la noticia completa
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navegando a la noticia completa...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: ResponsiveHelper.getContainerMinHeight(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getCardBorderRadius(context),
            ),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: ResponsiveHelper.getCardElevation(context),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getCardBorderRadius(context),
            ),
            child: Stack(
              children: [
                // Imagen de la noticia (placeholder por ahora)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade100, Colors.green.shade100],
                    ),
                  ),
                  child: Icon(
                    Icons.image,
                    size: ResponsiveHelper.getMenuButtonIconSize(context) * 2,
                    color: Colors.grey.shade400,
                  ),
                ),

                // Overlay con información de la noticia
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: ResponsiveHelper.getCardPadding(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Última Noticia',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getHeadingFontSize(
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ResponsiveHelper.verticalSpace(context, SpacingSize.xs),
                        Text(
                          'Toca para leer la noticia completa',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getCaptionFontSize(
                              context,
                            ),
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Indicador de que es clickeable
                Positioned(
                  top: ResponsiveHelper.getSmallSpacing(context),
                  right: ResponsiveHelper.getSmallSpacing(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: ResponsiveHelper.getCaptionFontSize(context),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
