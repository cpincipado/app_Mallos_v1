import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class MenuButtonsSection extends StatelessWidget {
  const MenuButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Calcular altura del grid basada en el tamaño de pantalla
    final buttonHeight = ResponsiveHelper.getButtonHeight(context) * 1.8;
    final gridHeight =
        (buttonHeight * 2) + ResponsiveHelper.getMediumSpacing(context);

    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: Container(
        // ✅ ALTURA CONTROLADA para evitar overflow
        height: gridHeight,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveHelper.getGridColumns(context), // Siempre 3
          mainAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
          crossAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
          childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.1 : 1.2,
          children: [
            // PARKING
            _buildMenuButton(
              context,
              icon: Icons.local_parking,
              title: 'Parking',
              subtitle: '',
              color: const Color(0xFF424242),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a aparcamientos...')),
                );
              },
            ),

            // XANTAMOS?
            _buildMenuButton(
              context,
              icon: Icons.restaurant,
              title: 'Xantamos?',
              subtitle: '',
              color: const Color(0xFF424242),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a restaurantes...')),
                );
              },
            ),

            // MERCAMOS?
            _buildMenuButton(
              context,
              icon: Icons.search,
              title: 'Mercamos?',
              subtitle: '',
              color: const Color(0xFF424242),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.merchants);
              },
            ),

            // NOVAS
            _buildMenuButton(
              context,
              icon: Icons.article,
              title: 'Novas',
              subtitle: '',
              color: const Color(0xFF424242),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
            ),

            // TARXETA
            _buildMenuButton(
              context,
              icon: Icons.card_membership,
              title: 'Tarxeta',
              subtitle: '',
              color: const Color(0xFF8BC34A), // Verde claro
              textColor: Colors.white,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.club);
              },
            ),

            // PROMOS
            _buildMenuButton(
              context,
              icon: Icons.local_offer,
              title: 'Promos',
              subtitle: '',
              color: const Color(0xFF424242),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a promociones...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getCardBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: ResponsiveHelper.getCardElevation(context),
              offset: const Offset(0, 2),
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
                icon,
                size: ResponsiveHelper.getMenuButtonIconSize(context),
                color: textColor,
              ),

              ResponsiveHelper.verticalSpace(context, SpacingSize.small),

              // Título responsive con protección de overflow
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getMenuButtonTitleSize(context),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Subtítulo si existe
              if (subtitle.isNotEmpty) ...[
                ResponsiveHelper.verticalSpace(context, SpacingSize.xs),
                Flexible(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getMenuButtonSubtitleSize(
                        context,
                      ),
                      color: textColor.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
