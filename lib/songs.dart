import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget.dart';

Future<void> saveCurrentSong(Song song) async {
  final prefs = await SharedPreferences.getInstance();
  final songJson = jsonEncode(song.toJson());
  await prefs.setString('currentSong', songJson);
}

Future<Song?> loadCurrentSong() async {
  final prefs = await SharedPreferences.getInstance();
  final songJson = prefs.getString('currentSong');
  if (songJson != null) {
    final songMap = jsonDecode(songJson);
    return Song.fromJson(songMap);
  }
  return null;
}

class Song {
  final String id;
  final String title;
  final String artist;
  final String assetPath;
  final String mp3Path;

  Song(
      {required this.id,
      required this.title,
      required this.artist,
      required this.assetPath,
      required this.mp3Path});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'assetPath': assetPath,
        'mp3Path': mp3Path,
      };

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json['id'],
        title: json['title'],
        artist: json['artist'],
        assetPath: json['assetPath'],
        mp3Path: json['mp3Path'],
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          artist == other.artist &&
          assetPath == other.assetPath &&
          mp3Path == other.mp3Path);

  @override
  int get hashCode =>
      title.hashCode ^ artist.hashCode ^ assetPath.hashCode ^ mp3Path.hashCode;
}

class Album {
  final String title;
  final String artist;
  final String assetPath;
  final List<Song> songs;

  Album({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.songs,
  });
  Map<String, dynamic> toJson() => {
        'title': title,
        'artist': artist,
        'assetPath': assetPath,
        'songs': songs.map((song) => song.toJson()).toList(),
      };

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        title: json['title'],
        artist: json['artist'],
        assetPath: json['assetPath'],
        songs: (json['songs'] as List)
            .map((songJson) => Song.fromJson(songJson))
            .toList(),
      );
}

final List<Album> albums = [
  Album(
    title: 'This is BINI',
    artist: 'BINI',
    assetPath: 'assets/covers/pantropiko.jpg',
    songs: [
      Song(
        id: 'bini_salamin', // Unique ID
        title: 'Salamin, Salamin',
        artist: 'BINI',
        assetPath: 'assets/covers/salamin, salamin.jpg',
        mp3Path: 'assets/audio/salamin, salamin.mp3',
      ),
      Song(
        id: 'bini_pantropiko', // Unique ID
        title: 'Pantropiko',
        artist: 'BINI',
        assetPath: 'assets/covers/pantropiko.jpg',
        mp3Path: 'assets/audio/bini-pantropiko.mp3',
      ),
      Song(
        id: 'bini_karera', // Unique ID
        title: 'Karera',
        artist: 'BINI',
        assetPath: 'assets/covers/karera.jpg',
        mp3Path: 'assets/audio/karera.mp3',
      ),
      Song(
        id: 'bini_lagi', // Unique ID
        title: 'Lagi',
        artist: 'BINI',
        assetPath: 'assets/covers/lagi.jpg',
        mp3Path: 'assets/audio/lagi.mp3',
      ),
      Song(
        id: 'bini_na_na_na', // Unique ID
        title: 'Na Na Na',
        artist: 'BINI',
        assetPath: 'assets/covers/na na na.jpg',
        mp3Path: 'assets/audio/na_na_na.mp3',
      ),
      Song(
        id: 'bini_cherry_on_top', // Unique ID
        title: 'Cherry On Top',
        artist: 'BINI',
        assetPath: 'assets/covers/cherry on top.jpg',
        mp3Path: 'assets/audio/cherry_on_top.mp3',
      ),
      // Add more songs here with unique IDs
    ],
  ),
  Album(
    title: 'This is Dionela',
    artist: 'Dionela',
    assetPath: 'assets/covers/dionela.jpg',
    songs: [
      Song(
        id: 'dionela_sining', // Unique ID
        title: 'sining (feat. Jay R)',
        artist: 'Dionela',
        assetPath: 'assets/covers/sining.jpg',
        mp3Path: 'assets/audio/sining.mp3',
      ),
      Song(
        id: 'dionela_hoodie', // Unique ID
        title: 'Hoodie (feat. Alisson Shore)',
        artist: 'Dionela',
        assetPath: 'assets/covers/hoodie.jpg',
        mp3Path: 'assets/audio/hoodie_feat_alisson_shore.mp3',
      ),
      Song(
        id: 'dionela_musika', // Unique ID
        title: 'Musika',
        artist: 'Dionela',
        assetPath: 'assets/covers/musika.jpg',
        mp3Path: 'assets/audio/musika.mp3',
      ),
      Song(
        id: 'dionela_oksihina', // Unique ID
        title: 'Oksihina',
        artist: 'Dionela',
        assetPath: 'assets/covers/oksihina.jpg',
        mp3Path: 'assets/audio/oksihina.mp3',
      ),
      Song(
        id: 'dionela_153', // Unique ID
        title: '153',
        artist: 'Dionela',
        assetPath: 'assets/covers/153.jpg',
        mp3Path: 'assets/audio/153.mp3',
      ),
      // Add more songs here with unique IDs
    ],
  ),
  Album(
    title: 'This is Maki',
    artist: 'Maki',
    assetPath: 'assets/covers/maki.jpg',
    songs: [
      Song(
        id: 'maki_dilaw', // Unique ID
        title: 'Dilaw',
        artist: 'Maki',
        assetPath: 'assets/covers/dilaw.jpg',
        mp3Path: 'assets/audio/dilaw.mp3',
      ),
      Song(
        id: 'maki_saan', // Unique ID
        title: 'Saan?',
        artist: 'Maki',
        assetPath: 'assets/covers/saan.jpg',
        mp3Path: 'assets/audio/saan.mp3',
      ),
      Song(
        id: 'maki_kailan', // Unique ID
        title: 'Kailan?',
        artist: 'Maki',
        assetPath: 'assets/covers/kailan.jpg',
        mp3Path: 'assets/audio/kailan.mp3',
      ),
      Song(
        id: 'maki_sikulo', // Unique ID
        title: 'Sikulo',
        artist: 'Maki',
        assetPath: 'assets/covers/sikulo.jpg',
        mp3Path: 'assets/audio/sikulo.mp3',
      ),
      Song(
        id: 'maki_bakit', // Unique ID
        title: 'Bakit?',
        artist: 'Maki',
        assetPath: 'assets/covers/bakit.jpg',
        mp3Path: 'assets/audio/bakit.mp3',
      ),
      // Add more songs here with unique IDs
    ],
  ),
  Album(
    title: 'This is Lola Amour',
    artist: 'Lola Amour',
    assetPath: 'assets/covers/lolaamour.png',
    songs: [
      Song(
        id: 'lolaamour_raining_in_manila', // Unique ID
        title: 'Raining In Manila',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/rain.png',
        mp3Path: 'assets/music/raining_in_manila.mp3',
      ),
      Song(
        id: 'lolaamour_fallen', // Unique ID
        title: 'Fallen',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/fallen.png',
        mp3Path: 'assets/music/fallen.mp3',
      ),
      Song(
        id: 'lolaamour_dahan_dahan', // Unique ID
        title: 'dahan-dahan',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/dahan.png',
        mp3Path: 'assets/music/dahan_dahan.mp3',
      ),
      Song(
        id: 'lolaamour_pwede_ba', // Unique ID
        title: 'Pwede Ba',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/pwede.png',
        mp3Path: 'assets/music/pwede_ba.mp3',
      ),
      Song(
        id: 'lolaamour_namimiss_ko_na', // Unique ID
        title: 'Namimiss Ko Na',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/miss.png',
        mp3Path: 'assets/music/namimiss_ko_na.mp3',
      ),
      // Add more songs here with unique IDs
    ],
  ),
  Album(
    title: 'This is Adie',
    artist: 'Adie',
    assetPath: 'assets/covers/adie.png',
    songs: [
      Song(
        id: 'adie_mahika', // Unique ID
        title: 'Mahika',
        artist: 'Adie',
        assetPath: 'assets/covers/mahika.png',
        mp3Path: 'assets/music/mahika.mp3',
      ),
      Song(
        id: 'adie_tahanan', // Unique ID
        title: 'Tahanan',
        artist: 'Adie',
        assetPath: 'assets/covers/tahan.png',
        mp3Path: 'assets/music/tahanan.mp3',
      ),
      Song(
        id: 'adie_paraluman', // Unique ID
        title: 'Paraluman',
        artist: 'Adie',
        assetPath: 'assets/covers/paraluman.png',
        mp3Path: 'assets/music/paraluman.mp3',
      ),
      Song(
        id: 'adie_oh_giliw', // Unique ID
        title: 'Oh, Giliw',
        artist: 'Adie',
        assetPath: 'assets/covers/giliw.png',
        mp3Path: 'assets/music/oh_giliw.mp3',
      ),
      Song(
        id: 'adie_kursunada', // Unique ID
        title: 'Kursunada',
        artist: 'Adie',
        assetPath: 'assets/covers/kursunada.png',
        mp3Path: 'assets/music/kursunada.mp3',
      ),
      // Add more songs here with unique IDs
    ],
  ),
];
