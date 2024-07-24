import '../widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorites';

  Future<void> addFavorite(String songId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(songId)) {
      favorites.add(songId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String songId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(songId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
}

// class AudioPlayerService {
//   static final AudioPlayer _player = AudioPlayer();

//   static void play(String url) async {
//     await _player.play(AssetSource(url));
//   }

//   static void pause() {
//     _player.pause();
//   }

//   static void stop() {
//     _player.stop();
//   }

//   static void dispose() {
//     _player.dispose();
//   }
// }
