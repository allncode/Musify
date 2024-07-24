import 'package:flutter/material.dart';
import '../widget.dart'; // Import your Song class

class FavoritesNotifier extends ChangeNotifier {
  final List<Song> _favorites = [];
  Song? _currentSong;
  Song? get currentSong => _currentSong;

  void setCurrentSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }

  List<Song> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Song song) => _favorites.contains(song);

  void addSong(Song song) {
    if (!_favorites.contains(song)) {
      _favorites.add(song);
      notifyListeners();
    }
  }

  void removeSong(Song song) {
    _favorites.remove(song);
    notifyListeners();
  }
}
