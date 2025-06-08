import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class MenuButtonsSection extends StatelessWidget {
  const MenuButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ RESPONSIVE: Calcular tamaños con LÍMITES MÁXIMOS
          final _ = constraints.maxWidth;
          final spacing = ResponsiveHelper.getMediumSpacing(context);

          // ✅ TAMAÑO MÁXIMO POR DISPOSITIVO - No crecen demasiado
          double maxItemWidth;
          if (ResponsiveHelper.isDesktop(context)) {
            maxItemWidth = 120; // Máximo 120px en desktop
          } else if (ResponsiveHelper.isTablet(context)) {
            maxItemWidth = 100; // Máximo 100px en tablet
          } else {
            maxItemWidth = 90; // Máximo 90px en mobile
          }

          // ✅ CAMBIO: Usar tamaño máximo en lugar de calcular dinámicamente
          // Esto mantiene los botones agrupados en todas las pantallas
          final itemWidth = maxItemWidth;
          final itemHeight = itemWidth * 0.9; // Aspect ratio fijo

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.isDesktop(context)
                    ? 400 // Máximo 400px en desktop
                    : ResponsiveHelper.isTablet(context)
                    ? 350 // Máximo 350px en tablet
                    : double.infinity, // Sin límite en mobile
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primera fila
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // ✅ VUELVE a spaceEvenly para mantener agrupación
                    children: [
                      _buildMenuButton(
                        context,
                        icon: Icons.local_parking,
                        title: 'Parking',
                        semanticsLabel: 'Navegar a aparcamientos',
                        color: const Color(0xFF424242),
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navegando a aparcamientos...'),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        context,
                        icon: Icons.restaurant,
                        title: 'Xantamos?',
                        semanticsLabel: 'Navegar a restaurantes',
                        color: const Color(0xFF424242),
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navegando a restaurantes...'),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        context,
                        icon: Icons.search,
                        title: 'Mercamos?',
                        semanticsLabel: 'Buscar comercios disponibles',
                        color: const Color(0xFF424242),
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.merchants);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: spacing),

                  // Segunda fila
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // ✅ VUELVE a spaceEvenly
                    children: [
                      _buildMenuButton(
                        context,
                        icon: Icons.article,
                        title: 'Novas',
                        semanticsLabel: 'Ver noticias y novedades',
                        color: const Color(0xFF424242),
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.notifications);
                        },
                      ),
                      _buildMenuButton(
                        context,
                        icon: Icons.card_membership,
                        title: 'Tarxeta',
                        semanticsLabel: 'Obtener tarjeta del club',
                        color: const Color(0xFF8BC34A), // Verde destacado
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.club);
                        },
                      ),
                      _buildMenuButton(
                        context,
                        icon: Icons.local_offer,
                        title: 'Promos',
                        semanticsLabel: 'Ver promociones disponibles',
                        color: const Color(0xFF424242),
                        textColor: Colors.white,
                        width: itemWidth,
                        height: itemHeight,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navegando a promociones...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String semanticsLabel,
    required Color color,
    required Color textColor,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      excludeSemantics: true, // Evita lecturas duplicadas
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        elevation: ResponsiveHelper.getCardElevation(context),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(
              ResponsiveHelper.isMobile(context) ? 8 : 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ ICONO CON TAMAÑO FIJO
                Icon(
                  icon,
                  size: ResponsiveHelper.getMenuButtonIconSize(context),
                  color: textColor,
                ),

                SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),

                // ✅ TÍTULO CON PROTECCIÓN TOTAL DE OVERFLOW
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width - 16, // Padding interno
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getMenuButtonTitleSize(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
