import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Accueil', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
