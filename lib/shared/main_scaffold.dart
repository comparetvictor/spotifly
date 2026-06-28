import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/home/home_page.dart';
import '../features/library/library_page.dart';
import '../features/player/player_page.dart';
import 'theme/app_theme.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  void navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _pages = const [
    HomePage(),
    PlayerPage(),
    LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.play_circle, color: AppColors.primary),
            label: 'Lecteur',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.library_music, color: AppColors.primary),
            label: 'Bibliothèque',
          ),
        ],
      ),
    );
  }
}
