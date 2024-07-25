import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../widget.dart'; // Import your Song class

class FavoritesNotifier extends ChangeNotifier {
  List<Song> _favorites = [];
  Song? _currentSong;
  String userId;

  FavoritesNotifier({required this.userId}) {
    if (userId.isNotEmpty) {
      _loadFavorites();
    }
  }

  void setUserId(String newUserId) {
    userId = newUserId;
    if (userId.isNotEmpty) {
      _loadFavorites();
    }
    notifyListeners();
  }

  List<Song> get favorites => _favorites;
  Song? get currentSong => _currentSong;

  void addSong(Song song) {
    if (!_favorites.contains(song)) {
      _favorites.add(song);
      _saveFavorites();
      notifyListeners();
      Fluttertoast.showToast(msg: "Song added to favorites");
    }
  }

  void removeSong(Song song) {
    if (_favorites.contains(song)) {
      _favorites.remove(song);
      _saveFavorites();
      notifyListeners();
      Fluttertoast.showToast(msg: "Song removed from favorites");
    }
  }

  bool isFavorite(Song song) {
    return _favorites.contains(song);
  }

  void setCurrentSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }

  void setFavorites(List<Song> newFavorites) {
    _favorites = newFavorites;
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList =
          _favorites.map((song) => jsonEncode(song.toJson())).toList();
      await prefs.setStringList('favorites_$userId', favoritesList);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList('favorites_$userId') ?? [];
      _favorites = favoritesList
          .map((songJson) => Song.fromJson(jsonDecode(songJson)))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // Public method to expose loading favorites functionality
  Future<void> loadFavorites() async {
    await _loadFavorites();
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
                  Fluttertoast.showToast(
                    msg: "${song.title} removed from favorites",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                  );
                } else {
                  favoritesNotifier.addSong(song);
                  Fluttertoast.showToast(
                    msg: "${song.title} added to favorites",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
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
