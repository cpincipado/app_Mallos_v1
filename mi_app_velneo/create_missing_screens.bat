@echo off
echo 🚀 Creando pantallas faltantes en español...

REM RegisterScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class RegisterScreen extends StatelessWidget {
echo   const RegisterScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Registro'^)^),
echo       body: const Center^(
echo         child: Text^('Pantalla de Registro', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\auth\register_screen.dart

REM HomeScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class HomeScreen extends StatelessWidget {
echo   const HomeScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Distrito Mallos'^)^),
echo       body: const Center^(
echo         child: Text^('Pantalla Principal', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\home\home_screen.dart

REM MerchantsScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class MerchantsScreen extends StatelessWidget {
echo   const MerchantsScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Comercios'^)^),
echo       body: const Center^(
echo         child: Text^('Lista de Comercios', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\merchants\merchants_screen.dart

REM ProfileScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class ProfileScreen extends StatelessWidget {
echo   const ProfileScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Mi Perfil'^)^),
echo       body: const Center^(
echo         child: Text^('Mi Perfil', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\profile\profile_screen.dart

REM PointsScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class PointsScreen extends StatelessWidget {
echo   const PointsScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Mis Puntos'^)^),
echo       body: const Center^(
echo         child: Text^('Mis Puntos del Club', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\points\points_screen.dart

REM NotificationsScreen
(
echo import 'package:flutter/material.dart';
echo.
echo class NotificationsScreen extends StatelessWidget {
echo   const NotificationsScreen^({super.key}^);
echo.
echo   @override
echo   Widget build^(BuildContext context^) {
echo     return Scaffold^(
echo       appBar: AppBar^(title: const Text^('Notificaciones'^)^),
echo       body: const Center^(
echo         child: Text^('Mis Notificaciones', style: TextStyle^(fontSize: 24^)^),
echo       ^),
echo     ^);
echo   }
echo }
) > lib\views\screens\notifications\notifications_screen.dart

echo ✅ Todas las pantallas han sido creadas en español!
echo.
echo 📱 Pantallas creadas:
echo - Registro
echo - Distrito Mallos ^(Principal^)
echo - Comercios  
echo - Mi Perfil
echo - Mis Puntos
echo - Notificaciones
echo.
echo 🚀 Ahora ejecuta: flutter run

pause