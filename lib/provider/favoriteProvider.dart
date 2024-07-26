import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../widget.dart';

class FavoritesNotifier extends ChangeNotifier {
  List<Song> _favorites = [];
  Song? _currentSong;
  String _userId = 'guest_user';

  void setUserId(String userId) {
    _userId = userId;
    if (_userId.isNotEmpty) {
      _loadFavorites();
    }
    notifyListeners();
  }

  List<Song> get favorites => _favorites;
  Song? get currentSong => _currentSong;

  void addSong(Song song) {
    print('Adding song: ${song.title}');
    if (!_favorites.contains(song)) {
      _favorites.add(song);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeSong(Song song) {
    print('Removing song: ${song.title}');
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

  void setFavorites(List<Song> newFavorites) {
    _favorites = newFavorites;
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList =
          _favorites.map((song) => jsonEncode(song.toJson())).toList();
      await prefs.setStringList('favorites_$_userId', favoritesList);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList('favorites_$_userId') ?? [];
      _favorites = favoritesList
          .map((songJson) => Song.fromJson(jsonDecode(songJson)))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

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
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text('Liked Songs'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
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
