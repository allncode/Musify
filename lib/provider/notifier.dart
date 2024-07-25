import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget.dart'; // Import your Song class

class RecentlyViewedNotifier extends ChangeNotifier {
  List<Album> _recentlyViewed = [];
  String _userId = 'guest_user';

  void setUserId(String userId) {
    _userId = userId;
    loadRecentlyViewed(); // Load data when userId is set
  }

  List<Album> get recentlyViewed => _recentlyViewed;

  void addAlbum(Album album) {
    // Add album to the list and persist
    _recentlyViewed.add(album);
    _saveRecentlyViewed();
    notifyListeners();
  }

  Future<void> loadRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentlyViewedList =
        prefs.getStringList('$_userId-recentlyViewed') ?? [];
    _recentlyViewed = recentlyViewedList.map((item) {
      final json = jsonDecode(item);
      return Album.fromJson(json);
    }).toList();
    notifyListeners();
  }

  Future<void> _saveRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentlyViewedList =
        _recentlyViewed.map((album) => jsonEncode(album.toJson())).toList();
    await prefs.setStringList('$_userId-recentlyViewed', recentlyViewedList);
  }
}

class RecentlyPlayedNotifier extends ChangeNotifier {
  List<Song> _recentlyPlayed = [];
  String _userId = 'guest_user';

  List<Song> get recentlyPlayed => _recentlyPlayed;

  void setUserId(String userId) {
    _userId = userId;
    loadRecentlyPlayed(); // Load data when userId is set
  }

  Future<void> loadRecentlyPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentlyPlayedList =
          prefs.getStringList('$_userId-recentlyPlayed') ?? [];
      _recentlyPlayed = recentlyPlayedList
          .map((songJson) => Song.fromJson(jsonDecode(songJson)))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading recently played songs: $e');
    }
  }

  Future<void> addSong(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> playedList =
        prefs.getStringList('$_userId-recentlyPlayed') ?? [];

    final songJson = jsonEncode(song.toJson());

    playedList.removeWhere((entry) {
      final entryData = jsonDecode(entry) as Map<String, dynamic>;
      return entryData['id'] == song.id;
    });

    playedList.add(songJson);
    if (playedList.length > 5) {
      playedList.removeAt(0);
    }

    await prefs.setStringList('$_userId-recentlyPlayed', playedList);
    _recentlyPlayed = playedList
        .map((songJson) => Song.fromJson(jsonDecode(songJson)))
        .toList();
    notifyListeners();
  }
}
