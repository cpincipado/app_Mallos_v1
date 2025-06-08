import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/optimized_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animación
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Iniciar animación
    _animationController.forward();

    // Navegar después de 3 segundos
    Timer(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Navegar directo a la pantalla principal
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo principal - OPTIMIZADO
                DistritoMallosLogo(
                  height: ResponsiveHelper.getSplashLogoWidth(context) * 0.6,
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.xl),

                // Indicador de carga - CENTRADO
                SizedBox(
                  width: ResponsiveHelper.isMobile(context) ? 32 : 40,
                  height: ResponsiveHelper.isMobile(context) ? 32 : 40,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    strokeWidth: 4,
                  ),
                ),

                ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                // Texto de carga
                Text(
                  'Cargando...',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
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
