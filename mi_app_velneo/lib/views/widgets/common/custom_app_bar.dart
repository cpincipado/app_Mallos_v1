import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showFavoriteButton;
  final bool showLogo;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showMenuButton = true,
    this.showFavoriteButton = true,
    this.showLogo = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.black.withValues(alpha: 0.25),

      // ✅ Borde inferior sutil
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey.shade200, height: 1.0),
      ),

      // ✅ Leading button con semantics
      leading: _buildLeadingButton(context),

      // ✅ Title responsive
      title: _buildTitle(context),

      centerTitle: true,

      // ✅ Actions responsive
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeadingButton(BuildContext context) {
    if (showBackButton) {
      return Semantics(
        label: 'Volver a la pantalla anterior',
        button: true,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              onBackPressed ??
              () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
          tooltip: 'Volver',
        ),
      );
    }

    if (showMenuButton) {
      return Semantics(
        label: 'Abrir menú de navegación',
        button: true,
        child: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menú',
          ),
        ),
      );
    }

    return null;
  }

  Widget? _buildTitle(BuildContext context) {
    if (title != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getScreenWidth(context) * 0.6,
        ),
        child: Text(
          title!,
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.getHeadingFontSize(context),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (showLogo) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: ResponsiveHelper.getAppBarLogoHeight(context),
          maxWidth: ResponsiveHelper.getScreenWidth(context) * 0.6,
        ),
        child: Image.asset(
          'assets/images/distrito_mallos_logo.png',
          height: ResponsiveHelper.getAppBarLogoHeight(context),
          fit: BoxFit.contain,
          semanticLabel: 'Logo Distrito Mallos',
          errorBuilder: (context, error, stackTrace) {
            // ✅ Fallback para logo
            return Container(
              height: ResponsiveHelper.getAppBarLogoHeight(context),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  'DISTRITO\nMALLOS',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            );
          },
        ),
      );
    }

    return null;
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [];

    // ✅ Logo adicional cuando hay título
    if (title != null && showLogo) {
      actions.add(
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: ResponsiveHelper.getAppBarLogoHeight(context) * 0.8,
              maxWidth: 60,
            ),
            child: Image.asset(
              'assets/images/distrito_mallos_logo.png',
              height: ResponsiveHelper.getAppBarLogoHeight(context) * 0.8,
              fit: BoxFit.contain,
              semanticLabel: 'Logo Distrito Mallos',
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.business,
                  color: Colors.green.shade700,
                  size: ResponsiveHelper.getMenuButtonIconSize(context) * 0.8,
                );
              },
            ),
          ),
        ),
      );
    }

    // ✅ Botón favoritos con semantics
    if (showFavoriteButton && title == null) {
      actions.add(
        Semantics(
          label: 'Ver favoritos',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navegando a favoritos...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Favoritos',
          ),
        ),
      );
    }

    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
