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

      // Body con layout JERÁRQUICO - Botones SIEMPRE visibles
      body: Column(
        children: [
          // Contenido principal scrolleable (noticias)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Espacio superior
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                  // Sección de noticias (imagen clickeable)
                  const NewsSection(),

                  // Espaciado entre noticia y botones
                  ResponsiveHelper.verticalSpace(context, SpacingSize.large),
                ],
              ),
            ),
          ),

          // BOTONES DEL MENÚ - SIEMPRE VISIBLES (prioridad máxima)
          Container(
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
                // Grid de 6 botones principales - FIJO y SIEMPRE VISIBLE
                SizedBox(
                  height: ResponsiveHelper.getMenuGridHeight(context),
                  child: const MenuButtonsSection(),
                ),

                // Espaciado antes del footer
                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
              ],
            ),
          ),

          // FOOTER - PEGADO ABAJO pero sin solapar botones
          Container(
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
                const FooterSection(),
                ResponsiveHelper.verticalSpace(context, SpacingSize.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
