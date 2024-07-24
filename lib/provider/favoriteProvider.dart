import '../widget.dart'; // Import your Song class

import 'package:flutter/material.dart';

class FavoritesNotifier extends ChangeNotifier {
  List<Song> _favorites = [];
  Song? _currentSong;

  List<Song> get favorites => _favorites;
  Song? get currentSong => _currentSong;

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

  bool isFavorite(Song song) {
    return _favorites.contains(song);
  }

  void setCurrentSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }
}
