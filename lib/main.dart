import 'package:flutter/material.dart';
import 'package:poseidon/core/theme/app_theme.dart';
import 'package:poseidon/ui/features/home/views/home_map_screen.dart';

void main() {
  runApp(const PoseidonApp());
}

class PoseidonApp extends StatelessWidget {
  const PoseidonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poseidon Smart Parking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeMapScreen(),
    );
  }
}
