import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/audio_provider.dart';
import '../../shared/theme/app_theme.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();
    final screenHeight = MediaQuery.of(context).size.height;
    final albumSize = screenHeight * 0.3;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: albumSize,
                  height: albumSize,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: provider.currentTrack == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_note,
                                color: AppColors.textSecondary,
                                size: albumSize * 0.2),
                            const SizedBox(height: 8),
                            const Text('Aucun morceau sélectionné',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        )
                      : Icon(Icons.music_note,
                          color: AppColors.primary, size: albumSize * 0.3),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                provider.currentTrack?.title ?? 'Aucun morceau',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fichier local',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),

              const SizedBox(height: 24),

              Slider(
                value: provider.progress.clamp(0.0, 1.0),
                onChangeStart: (_) => provider.seekStart(),
                onChanged: provider.currentTrack != null
                    ? (value) => provider.updateProgress(value)
                    : null,
                onChangeEnd: provider.currentTrack != null
                    ? (value) => provider.seekEnd(value)
                    : null,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.card,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(provider.formatDuration(provider.position),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    Text(provider.formatDuration(provider.duration),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: AppColors.textPrimary, size: 36),
                    onPressed: provider.currentTrack != null
                        ? () => provider.restart()
                        : null,
                  ),
                  GestureDetector(
                    onTap: provider.currentTrack != null
                        ? () => provider.togglePlay()
                        : null,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: provider.currentTrack != null
                            ? AppColors.primary
                            : AppColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        provider.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.background,
                        size: 36,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: AppColors.textPrimary, size: 36),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.volume_down, color: AppColors.textSecondary),
                  Expanded(
                    child: Slider(
                      value: provider.volume,
                      onChanged: (value) => provider.setVolume(value),
                      activeColor: AppColors.textSecondary,
                      inactiveColor: AppColors.card,
                    ),
                  ),
                  const Icon(Icons.volume_up, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
