import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget.dart';

class RecentlyViewedNotifier extends ChangeNotifier {
  List<Album> _recentlyViewed = [];
  String _userId = 'guest_user';

  void setUserId(String userId) {
    _userId = userId;
    loadRecentlyViewed(); // Load data when userId is set
  }

  List<Album> get recentlyViewed => _recentlyViewed;

  void addAlbum(Album album) {
    _recentlyViewed.remove(album);

    _recentlyViewed.insert(0, album);

    final int _maxItems = 10;
    if (_recentlyViewed.length > _maxItems) {
      _recentlyViewed.removeLast();
    }

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
  final int _maxItems = 3;
  List<Album> _recentlyViewed = [];

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

  void addAlbum(Album album) {
    // Remove the oldest album if the list exceeds the maximum length
    if (_recentlyViewed.length >= _maxItems) {
      _recentlyViewed.removeLast();
    }

    // Remove the album if it already exists to add it to the front
    _recentlyViewed.remove(album);

    // Add the new album to the front of the list
    _recentlyViewed.insert(0, album);

    notifyListeners();
  }
}
