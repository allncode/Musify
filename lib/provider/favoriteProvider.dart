import 'package:flutter/material.dart';
import '../widget.dart'; // Ensure you import the Song class

import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<Song> _favorites = {};

  bool isFavorite(Song song) => _favorites.contains(song);

  void toggleFavorite(Song song) {
    if (_favorites.contains(song)) {
      _favorites.remove(song);
    } else {
      _favorites.add(song);
    }
    notifyListeners();
  }
}
