import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bibliothèque', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
