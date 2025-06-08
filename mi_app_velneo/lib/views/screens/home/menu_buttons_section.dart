import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class MenuButtonsSection extends StatelessWidget {
  const MenuButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getHorizontalPadding(context),
      child: ConstrainedBox(
        // ✅ ALTURA MÁXIMA ABSOLUTA - NO PUEDE CRECER MÁS DE 320px
        constraints: const BoxConstraints(
          maxHeight: 320, // LÍMITE ABSOLUTO
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3, // SIEMPRE 3 COLUMNAS
          mainAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
          crossAxisSpacing: ResponsiveHelper.getMediumSpacing(context),
          // ✅ ASPECT RATIO FIJO - NO CRECE MÁS
          childAspectRatio: _getFixedAspectRatio(context),
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

  // ✅ ASPECT RATIO COMPLETAMENTE FIJO - AQUÍ ESTABA EL PROBLEMA
  double _getFixedAspectRatio(BuildContext context) {
    // NO cambia según el tamaño de pantalla
    return 1.2; // FIJO para todos los tamaños
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
        // ✅ CONSTRAINTS ABSOLUTOS - NO PUEDE EXCEDER ESTOS LÍMITES
        constraints: const BoxConstraints(
          maxHeight: 150, // LÍMITE ABSOLUTO por botón
          minHeight: 100,
        ),
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
          padding: EdgeInsets.all(
            ResponsiveHelper.isMobile(context) ? 8.0 : 12.0,
          ), // Padding limitado
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ ICONO CON TAMAÑO MÁXIMO ABSOLUTO
              Icon(
                icon,
                size: _getControlledIconSize(context),
                color: textColor,
              ),

              const SizedBox(height: 8), // Espaciado fijo
              // ✅ TÍTULO CON FITBOX Y LÍMITES ESTRICTOS
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: _getControlledTextSize(context),
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Subtítulo si existe
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: _getControlledTextSize(context) * 0.85,
                        color: textColor.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ✅ TAMAÑO DE ICONO CON LÍMITE MÁXIMO ABSOLUTO
  double _getControlledIconSize(BuildContext context) {
    final baseSize = ResponsiveHelper.getMenuButtonIconSize(context);
    // LÍMITE ABSOLUTO - NUNCA MÁS DE 32px
    return baseSize.clamp(20.0, 32.0);
  }

  // ✅ TAMAÑO DE TEXTO CON LÍMITE MÁXIMO ABSOLUTO
  double _getControlledTextSize(BuildContext context) {
    final baseSize = ResponsiveHelper.getMenuButtonTitleSize(context);
    // LÍMITE ABSOLUTO - NUNCA MÁS DE 14px
    return baseSize.clamp(11.0, 14.0);
  }
}
