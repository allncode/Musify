import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget.dart';

class Favorites {
  static final List<Song> _favorites = [];

  static List<Song> getFavorites() => List.unmodifiable(_favorites);

  static bool isFavorite(Song song) => _favorites.contains(song);

  static void addSong(Song song) {
    if (!_favorites.contains(song)) {
      _favorites.add(song);
    }
  }

  static void removeSong(Song song) {
    _favorites.remove(song);
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
        elevation: 0, // Removes the shadow
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
                } else {
                  favoritesNotifier.addSong(song);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
