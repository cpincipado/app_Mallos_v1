import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/config/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer con logo eu mallos
          SizedBox(
            height: 200,
            child: Container(
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menú',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Logo eu mallos
                  SizedBox(
                    width: 150,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Corazón + eu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, color: Colors.red, size: 24),
                            Text(
                              'eu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // mallos
                        Text(
                          'mallos',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            height: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Asóciate
          ListTile(
            leading: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.store_outlined, color: Colors.grey, size: 20),
            ),
            title: const Text(
              'Asóciate',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.associate);
            },
          ),

          const SizedBox(height: 10),

          // Login Asociados
          ListTile(
            leading: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.people_outline, color: Colors.grey, size: 20),
            ),
            title: const Text(
              'Login Asociados',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),

          const SizedBox(height: 10),

          // Ajustes
          ListTile(
            leading: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.settings_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
            title: const Text(
              'Ajustes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración de la app')),
              );
            },
          ),
        ],
      ),
    );
  }
}
