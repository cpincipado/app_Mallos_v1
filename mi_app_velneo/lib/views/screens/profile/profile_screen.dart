import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: const Center(
        child: Text('Mi Perfil', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
