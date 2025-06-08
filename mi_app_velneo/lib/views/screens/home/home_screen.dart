import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_drawer.dart';
import 'package:mi_app_velneo/views/screens/home/news_section.dart';
import 'package:mi_app_velneo/views/screens/home/menu_buttons_section.dart';
import 'package:mi_app_velneo/views/screens/home/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      // AppBar personalizado
      appBar: const CustomAppBar(),

      // Menú lateral personalizado
      drawer: const CustomDrawer(),

      // Body con todas las secciones - COMPLETAMENTE RESPONSIVE
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Espacio superior - RESPONSIVE
            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

            // Sección de noticias - RESPONSIVE
            const NewsSection(),

            // Espaciado - RESPONSIVE
            ResponsiveHelper.verticalSpace(context, SpacingSize.large),

            // Grid de 6 botones principales - RESPONSIVE
            const MenuButtonsSection(),

            // Espaciado - RESPONSIVE
            ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

            // Footer con logos institucionales - RESPONSIVE
            const FooterSection(),

            // Espacio inferior - RESPONSIVE
            ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          ],
        ),
      ),
    );
  }
}
