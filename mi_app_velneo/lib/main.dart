import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/config/routes.dart';
import 'package:mi_app_velneo/services/news_service.dart'; // ✅ AÑADIR IMPORT

void main() async {
  // ✅ AÑADIR ESTAS 3 LÍNEAS
  WidgetsFlutterBinding.ensureInitialized();
  await NewsService.initialize(); // ✅ Inicializar cache de noticias

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distrito Mallos',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false, // Quita el banner de debug
    );
  }
}
