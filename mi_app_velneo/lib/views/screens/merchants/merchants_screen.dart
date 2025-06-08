import 'package:flutter/material.dart';

class MerchantsScreen extends StatelessWidget {
  const MerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comercios')),
      body: const Center(
        child: Text('Lista de Comercios', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
