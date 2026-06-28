import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/audio_provider.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/main_scaffold.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _selectionMode = false;
  final Set<String> _selected = {};

  Future<void> _addFiles(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'flac', 'm4a'],
      allowMultiple: true,
    );

    if (result != null) {
      final provider = context.read<AudioProvider>();
      for (final file in result.files) {
        if (file.path != null) {
          provider.addTrack(file.path!, file.name);
        }
      }
    }
  }

  void _toggleSelection(String path) {
    setState(() {
      if (_selected.contains(path)) {
        _selected.remove(path);
      } else {
        _selected.add(path);
      }
    });
  }

  void _deleteSelected(AudioProvider provider) {
    final toDelete = provider.tracks
        .where((t) => _selected.contains(t.path))
        .toList();
    for (final track in toDelete) {
      provider.removeTrack(track);
    }
    setState(() {
      _selected.clear();
      _selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectionMode
                        ? '${_selected.length} sélectionné(s)'
                        : 'Ma bibliothèque',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (_selectionMode) ...[
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: _selected.isEmpty
                              ? null
                              : () => _deleteSelected(provider),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textPrimary),
                          onPressed: () {
                            setState(() {
                              _selectionMode = false;
                              _selected.clear();
                            });
                          },
                        ),
                      ] else ...[
                        IconButton(
                          icon: const Icon(Icons.checklist,
                              color: AppColors.textPrimary),
                          onPressed: () =>
                              setState(() => _selectionMode = true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add,
                              color: AppColors.textPrimary),
                          onPressed: () => _addFiles(context),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.tracks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.library_music,
                              color: AppColors.textSecondary, size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun morceau ajouté',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () => _addFiles(context),
                            icon: const Icon(Icons.add,
                                color: AppColors.primary),
                            label: const Text('Ajouter des morceaux',
                                style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.tracks.length,
                      itemBuilder: (context, index) {
                        final track = provider.tracks[index];
                        final isPlaying = provider.currentTrack == track;
                        final isSelected = _selected.contains(track.path);

                        return _selectionMode
                            ? ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) =>
                                      _toggleSelection(track.path),
                                  activeColor: AppColors.primary,
                                ),
                                title: Text(
                                  track.title,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: const Text(
                                  'Fichier local',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12),
                                ),
                                onTap: () => _toggleSelection(track.path),
                              )
                            : Dismissible(
                                key: Key(track.path),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (_) =>
                                    provider.removeTrack(track),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isPlaying
                                          ? AppColors.primary.withOpacity(0.2)
                                          : AppColors.card,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.equalizer
                                          : Icons.music_note,
                                      color: isPlaying
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  title: Text(
                                    track.title,
                                    style: TextStyle(
                                      color: isPlaying
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: const Text(
                                    'Fichier local',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12),
                                  ),
                                  onTap: () {
                                    provider.playTrack(track);
                                    final scaffold = context.findAncestorStateOfType<MainScaffoldState>();
                                    scaffold?.navigateTo(1);
                                    },
                                ),
                              );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

