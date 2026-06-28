import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Track {
  final String path;
  final String title;

  Track({required this.path, required this.title});

  @override
  bool operator ==(Object other) => other is Track && other.path == path;

  @override
  int get hashCode => path.hashCode;
}

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<Track> _tracks = [];
  Track? _currentTrack;
  bool _isPlaying = false;
  double _progress = 0.0;
  double _volume = 0.7;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _completed = false;
  bool _seeking = false;

  List<Track> get tracks => _tracks;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  double get volume => _volume;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get completed => _completed;

  AudioProvider() {
    _initListeners();
    _player.setVolume(_volume);
  }

  void _initListeners() {
    _player.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _player.onPositionChanged.listen((p) {
      if (!_seeking) {
        _position = p;
        _progress = _duration.inSeconds > 0
            ? _position.inSeconds / _duration.inSeconds
            : 0.0;
        notifyListeners();
      }
    });

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (state == PlayerState.completed) _completed = true;
      notifyListeners();
    });
  }

  void addTrack(String path, String name) {
    final title = name.replaceAll(RegExp(r'\.[^.]+$'), '');
    final track = Track(path: path, title: title);
    if (!_tracks.contains(track)) {
      _tracks.add(track);
      notifyListeners();
    }
  }

  Future<void> playTrack(Track track) async {
    _currentTrack = track;
    _completed = false;
    _progress = 0.0;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
    await _player.play(DeviceFileSource(track.path));
  }

  Future<void> togglePlay() async {
    if (_currentTrack == null) return;
    if (_completed) {
      _completed = false;
      await _player.play(DeviceFileSource(_currentTrack!.path));
    } else if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  Future<void> seekStart() async {
    _seeking = true;
    if (_isPlaying) await _player.pause();
  }

  Future<void> seekEnd(double value) async {
    final position = Duration(
      seconds: (value * _duration.inSeconds).toInt(),
    );
    await _player.seek(position);
    _progress = value;
    _position = position;
    _seeking = false;
    notifyListeners();
    if (!_completed) await _player.resume();
  }

  void updateProgress(double value) {
    _progress = value;
    _position = Duration(
      seconds: (value * _duration.inSeconds).toInt(),
    );
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    await _player.setVolume(value);
    notifyListeners();
  }

  Future<void> restart() async {
    _completed = false;
    await _player.seek(Duration.zero);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
