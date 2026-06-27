import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import '../../shared/theme/app_theme.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _progress = 0.0;
  double _volume = 0.7;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _completed = false;
  bool _seeking = false;
  String _title = 'Aucun fichier sélectionné';
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _initListeners();
  }

  void _initListeners() {
    _player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      if (!_seeking) {
        setState(() {
          _position = p;
          _progress = _duration.inSeconds > 0
              ? _position.inSeconds / _duration.inSeconds
              : 0.0;
        });
      }
    });

    _player.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.completed) _completed = true;
      });
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'flac', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final name = result.files.single.name;

      setState(() {
        _filePath = path;
        _title = name.replaceAll(RegExp(r'\.[^.]+$'), '');
        _completed = false;
        _progress = 0.0;
        _position = Duration.zero;
        _duration = Duration.zero;
      });

      await _player.play(DeviceFileSource(path));
    }
  }

  Future<void> _togglePlay() async {
    if (_filePath == null) {
      await _pickFile();
      return;
    }
    if (_completed) {
      _completed = false;
      await _player.play(DeviceFileSource(_filePath!));
    } else if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  Future<void> _onSeekStart(double value) async {
    _seeking = true;
    if (_isPlaying) await _player.pause();
  }

  Future<void> _onSeekEnd(double value) async {
    final position = Duration(
      seconds: (value * _duration.inSeconds).toInt(),
    );
    await _player.seek(position);
    setState(() {
      _progress = value;
      _position = position;
      _seeking = false;
    });
    if (!_completed) await _player.resume();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

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
              GestureDetector(
                onTap: _pickFile,
                child: Center(
                  child: Container(
                    width: albumSize,
                    height: albumSize,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _filePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: AppColors.primary, size: albumSize * 0.2),
                              const SizedBox(height: 8),
                              const Text('Choisir un fichier',
                                  style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          )
                        : Icon(Icons.music_note, color: AppColors.primary, size: albumSize * 0.3),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                _title,
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
                value: _progress.clamp(0.0, 1.0),
                onChangeStart: _onSeekStart,
                onChanged: (value) {
                  setState(() {
                    _progress = value;
                    _position = Duration(
                      seconds: (value * _duration.inSeconds).toInt(),
                    );
                  });
                },
                onChangeEnd: _onSeekEnd,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.card,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text(_formatDuration(_duration),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
                    icon: const Icon(Icons.skip_previous, color: AppColors.textPrimary, size: 36),
                    onPressed: () {
                      _completed = false;
                      _player.seek(Duration.zero);
                    },
                  ),
                  GestureDetector(
                    onTap: _togglePlay,
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
                    onPressed: () => _player.seek(_duration),
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
                      value: _volume,
                      onChanged: (value) {
                        setState(() => _volume = value);
                        _player.setVolume(value);
                      },
                      activeColor: AppColors.textSecondary,
                      inactiveColor: AppColors.card,
                    ),
                  ),
                  const Icon(Icons.volume_up, color: AppColors.textSecondary),
                ],
              ),

              const SizedBox(height: 16),

              TextButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open, color: AppColors.primary),
                label: const Text(
                  'Changer de fichier',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
