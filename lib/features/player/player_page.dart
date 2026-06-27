import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _isPlaying = false;
  double _progress = 0.3;
  double _volume = 0.7;

  @override
  Widget build(BuildContext context) {
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
              // Pochette adaptive
              Center(
                child: Container(
                  width: albumSize,
                  height: albumSize,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: AppColors.primary,
                    size: albumSize * 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Titre et artiste
              const Text(
                'Titre du morceau',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nom de l\'artiste',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Barre de progression
              Slider(
                value: _progress,
                onChanged: (value) => setState(() => _progress = value),
                activeColor: AppColors.primary,
                inactiveColor: AppColors.card,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('1:12', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('3:45', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contrôles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: AppColors.textPrimary, size: 36),
                    onPressed: () {},
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.background,
                        size: 36,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: AppColors.textPrimary, size: 36),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Volume
              Row(
                children: [
                  const Icon(Icons.volume_down, color: AppColors.textSecondary),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      onChanged: (value) => setState(() => _volume = value),
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
