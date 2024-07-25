import 'package:flutter/material.dart';
import '../widget.dart'; // Import your Song class

class PlaybackProvider with ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;
  List<Song> _playlist = [];

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;

  void setPlaylist(List<Song> playlist) {
    _playlist = playlist;
    notifyListeners();
  }

  void playSong(Song song) {
    _currentSong = song;
    _isPlaying = true;
    notifyListeners();
    // Add your play logic here
  }

  void pauseSong() {
    _isPlaying = false;
    notifyListeners();
    // Add your pause logic here
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pauseSong();
    } else {
      if (_currentSong == null) {
        // Handle case where no song is currently playing
      } else {
        playSong(_currentSong!);
      }
    }
  }

  void nextSong() {
    if (_currentSong == null || _playlist.isEmpty) return;

    final currentIndex = _playlist.indexOf(_currentSong!);
    if (currentIndex < _playlist.length - 1) {
      _currentSong = _playlist[currentIndex + 1];
      playSong(_currentSong!);
    }
  }

  void previousSong() {
    if (_currentSong == null || _playlist.isEmpty) return;

    final currentIndex = _playlist.indexOf(_currentSong!);
    if (currentIndex > 0) {
      _currentSong = _playlist[currentIndex - 1];
      playSong(_currentSong!);
    }
  }
}
