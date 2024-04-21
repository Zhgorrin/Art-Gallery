// myart.dart
import 'package:flutter/material.dart';

class MyArtScreen extends StatelessWidget {
  const MyArtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Art'),
      ),
      body: const Center(
        child: Text('This is My Art Page'),
      ),
    );
  }
}
