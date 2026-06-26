import 'package:flutter/material.dart';
import 'shared/theme/app_theme.dart';
import 'shared/main_scaffold.dart';

void main() {
  runApp(const SpotiflyApp());
}

class SpotiflyApp extends StatelessWidget {
  const SpotiflyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotifly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScaffold(),
    );
  }
}
