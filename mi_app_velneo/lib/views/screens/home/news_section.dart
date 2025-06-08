import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: Container(
        width: double.infinity,
        // ✅ ALTURA ADAPTABLE en lugar de fija
        constraints: BoxConstraints(
          minHeight: ResponsiveHelper.getContainerMinHeight(context) * 0.8,
          maxHeight: ResponsiveHelper.getContainerMinHeight(context) * 1.2,
        ),
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
        child: Padding(
          padding: ResponsiveHelper.getCardPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono responsive
              Icon(
                Icons.newspaper,
                size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
                color: Colors.grey,
              ),

              ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

              // Título responsive
              Text(
                'Última Noticia',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getHeadingFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              ResponsiveHelper.verticalSpace(context, SpacingSize.small),

              // Descripción responsive
              Flexible(
                child: Text(
                  'Las noticias se cargarán desde la API',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    color: Colors.grey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
