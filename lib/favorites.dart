import 'widget.dart'; 

class Favorites {
  static final List<Song> _favorites = [];

  static List<Song> get favorites => List.unmodifiable(_favorites);

  static void addSong(Song song) {
    if (!_favorites.contains(song)) {
      _favorites.add(song);
    }
  }

  static void removeSong(Song song) {
    _favorites.remove(song);
  }

  static bool isFavorite(Song song) {
    return _favorites.contains(song);
  }
}
