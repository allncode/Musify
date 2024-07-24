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

class PreferenceService {
  static const String _currentSongKey = 'currentSong';
  static const String _isPlayingKey = 'isPlaying';

  Future<void> saveCurrentSong(String songJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentSongKey, songJson);
  }

  Future<String?> loadCurrentSong() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentSongKey);
  }

  Future<void> saveIsPlaying(bool isPlaying) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPlayingKey, isPlaying);
  }

  Future<bool> loadIsPlaying() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPlayingKey) ?? false;
  }
}
