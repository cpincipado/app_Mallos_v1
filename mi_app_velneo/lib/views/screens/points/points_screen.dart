import 'package:flutter/material.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Puntos')),
      body: const Center(
        child: Text('Mis Puntos del Club', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
