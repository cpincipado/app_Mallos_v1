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

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey.shade200, height: 1.0),
      ),

      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : showMenuButton
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,

      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )
          : showLogo
          ? Image.asset(
              'assets/images/distrito_mallos_logo.png',
              height: ResponsiveHelper.getAppBarLogoHeight(context),
              fit: BoxFit.contain,
            )
          : null,

      centerTitle: true,

      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [];

    if (title != null && showLogo) {
      actions.add(
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(
            'assets/images/distrito_mallos_logo.png',
            height: ResponsiveHelper.getAppBarLogoHeight(context) * 0.8,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    if (showFavoriteButton && title == null) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.star_border, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navegando a favoritos...')),
            );
          },
        ),
      );
    }

    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
