import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Lecteur', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
