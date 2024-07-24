import 'package:provider/provider.dart';

import '../widget.dart'; // Import your Song class

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritesNotifier extends ChangeNotifier {
  List<Song> _favorites = [];
  Song? _currentSong;

  List<Song> get favorites => _favorites;
  Song? get currentSong => _currentSong;

  FavoritesNotifier() {
    _loadFavorites();
  }

  void addSong(Song song) {
    if (!_favorites.contains(song)) {
      _favorites.add(song);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeSong(Song song) {
    if (_favorites.contains(song)) {
      _favorites.remove(song);
      _saveFavorites();
      notifyListeners();
    }
  }

  bool isFavorite(Song song) {
    return _favorites.contains(song);
  }

  void setCurrentSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList =
        _favorites.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('favorites', favoritesList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favorites') ?? [];
    _favorites = favoritesList
        .map((songJson) => Song.fromJson(jsonDecode(songJson)))
        .toList();
    notifyListeners();
  }
}

class LikedSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    final likedSongs = favoritesNotifier.favorites;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Liked Songs', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: likedSongs.length,
        itemBuilder: (context, index) {
          final song = likedSongs[index];
          return ListTile(
            leading: Image.asset(song.assetPath),
            title: Text(song.title, style: TextStyle(color: Colors.white)),
            subtitle: Text(song.artist, style: TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(
                favoritesNotifier.isFavorite(song)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favoritesNotifier.isFavorite(song)
                    ? Colors.redAccent
                    : Colors.white,
              ),
              onPressed: () {
                if (favoritesNotifier.isFavorite(song)) {
                  favoritesNotifier.removeSong(song);
                  print("${song.title} removed from favorites"); // Debugging
                  Fluttertoast.showToast(
                    msg: "${song.title} removed from favorites",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                  );
                } else {
                  favoritesNotifier.addSong(song);
                  print("${song.title} added to favorites"); // Debugging
                  Fluttertoast.showToast(
                    msg: "${song.title} added to favorites",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
