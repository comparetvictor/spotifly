import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ma bibliothèque',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Filtres
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Playlists', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Albums', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Artistes', false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Liste
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildPlaylistItem('Ma playlist ', ' titres');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.background : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPlaylistItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.music_note, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
