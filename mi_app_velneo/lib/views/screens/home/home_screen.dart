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

      // ✅ NUEVO: Layout con footer pegado al final
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ Altura disponible sin AppBar
          final _ = constraints.maxHeight;

          return Column(
            children: [
              // ✅ ESPACIO SUPERIOR FIJO
              SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),

              // ✅ SECCIÓN DE NOTICIAS - EXPANDIBLE
              Expanded(
                child: Padding(
                  padding: ResponsiveHelper.getHorizontalPadding(context),
                  child: const NewsSection(),
                ),
              ),

              // ✅ ESPACIADO ENTRE NOTICIAS Y MENÚ - FIJO
              SizedBox(height: ResponsiveHelper.getLargeSpacing(context)),

              // ✅ BOTONES DEL MENÚ - SIEMPRE VISIBLES (FIJO)
              const MenuButtonsSection(),

              // ✅ ESPACIADO ANTES DEL FOOTER - FIJO
              SizedBox(height: ResponsiveHelper.getLargeSpacing(context)),

              // ✅ FOOTER - SIEMPRE AL FINAL (FIJO)
              const FooterSection(),

              // ✅ ESPACIO INFERIOR - FIJO
              SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),
            ],
          );
        },
      ),
    );
  }
}
