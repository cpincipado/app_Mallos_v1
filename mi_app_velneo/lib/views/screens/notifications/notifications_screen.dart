// lib/views/screens/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/views/screens/news/news_list_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirigir directamente a la pantalla de noticias
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewsListScreen()),
      );
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
