import 'package:flutter/material.dart';
import 'package:mi_app_velneo/views/screens/splash/splash_screen.dart';
import 'package:mi_app_velneo/views/screens/home/home_screen.dart';
import 'package:mi_app_velneo/views/screens/auth/login_screen.dart';
import 'package:mi_app_velneo/views/screens/auth/register_screen.dart';
import 'package:mi_app_velneo/views/screens/merchants/merchants_screen.dart';
import 'package:mi_app_velneo/views/screens/profile/profile_screen.dart';
import 'package:mi_app_velneo/views/screens/points/points_screen.dart';
import 'package:mi_app_velneo/views/screens/notifications/notifications_screen.dart';
import 'package:mi_app_velneo/views/screens/associate/associate_screen.dart';
import 'package:mi_app_velneo/views/screens/privacy/privacy_screen.dart';
import 'package:mi_app_velneo/views/screens/club/club_screen.dart';
import 'package:mi_app_velneo/views/screens/news/news_list_screen.dart';
import 'package:mi_app_velneo/views/screens/news/news_detail_screen.dart';
import 'package:mi_app_velneo/views/screens/parking/parking_screen.dart';
// ✅ NUEVOS IMPORTS
import 'package:mi_app_velneo/views/screens/restaurants/restaurants_screen.dart';
import 'package:mi_app_velneo/views/screens/merchant/merchant_dashboard_screen.dart';

class AppRoutes {
  // Nombres de las rutas
  static const String splash = '/';
  static const String login = '/login'; // ✅ REVERTIDO - Login normal
  static const String register = '/register';
  static const String home = '/home';
  static const String merchants = '/merchants';
  static const String profile = '/profile';
  static const String points = '/points';
  static const String notifications = '/notifications';
  static const String associate = '/associate';
  static const String privacy = '/privacy';
  static const String club = '/club';
  static const String newsList = '/news';
  static const String newsDetail = '/news/detail';
  static const String parking = '/parking';
  // ✅ NUEVAS RUTAS
  static const String restaurants = '/restaurants';
  static const String merchantDashboard = '/merchant-dashboard';

  // Mapa de rutas
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(), // ✅ REVERTIDO
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      merchants: (context) => const MerchantsScreen(),
      profile: (context) => const ProfileScreen(),
      points: (context) => const PointsScreen(),
      notifications: (context) => const NotificationsScreen(),
      associate: (context) => const AssociateScreen(),
      privacy: (context) => const PrivacyScreen(),
      club: (context) => const ClubScreen(),
      newsList: (context) => const NewsListScreen(),
      parking: (context) => const ParkingScreen(),
      // ✅ NUEVAS RUTAS
      restaurants: (context) => const RestaurantsScreen(),
      merchantDashboard: (context) => const MerchantDashboardScreen(),
    };
  }

  // Navegación helper methods
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToScreen(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToNews(BuildContext context) {
    Navigator.pushNamed(context, newsList);
  }

  static void navigateToNewsDetail(BuildContext context, String newsId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsDetailScreen(newsId: newsId)),
    );
  }

  static void navigateToParking(BuildContext context) {
    Navigator.pushNamed(context, parking);
  }

  // ✅ NUEVAS NAVEGACIONES
  static void navigateToRestaurants(BuildContext context) {
    Navigator.pushNamed(context, restaurants);
  }

  static void navigateToMerchantDashboard(BuildContext context) {
    Navigator.pushNamed(context, merchantDashboard);
  }
}
