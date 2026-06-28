import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/audio_provider.dart';
import '../theme/app_theme.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;

  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    if (provider.currentTrack == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: AppColors.primary),
            ),

            // Titre + barre de progression
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.currentTrack!.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: provider.progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.surface,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 2,
                  ),
                ],
              ),
            ),

            // Boutons
            IconButton(
              icon: const Icon(Icons.skip_previous,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => provider.playPrevious(),
            ),
            IconButton(
              icon: Icon(
                provider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primary,
                size: 28,
              ),
              onPressed: () => provider.togglePlay(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => provider.playNext(),
            ),
          ],
        ),
      ),
    );
  }
}
