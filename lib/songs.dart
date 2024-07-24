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
  final String title;
  final String artist;
  final String assetPath;
  final String mp3Path;

  Song({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.mp3Path,
  });

  // Convert Song to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'assetPath': assetPath,
      'mp3Path': mp3Path,
    };
  }

  // Create Song from JSON
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'],
      assetPath: json['assetPath'],
      mp3Path: json['mp3Path'],
    );
  }
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

  // Convert Album to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'assetPath': assetPath,
      'songs': songs.map((song) => song.toJson()).toList(),
    };
  }

  // Create Album from JSON
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      artist: json['artist'],
      assetPath: json['assetPath'],
      songs: (json['songs'] as List)
          .map((songJson) => Song.fromJson(songJson))
          .toList(),
    );
  }
}

final List<Album> albums = [
  Album(
    title: 'This is BINI',
    artist: 'BINI',
    assetPath: 'assets/covers/pantropiko.jpg',
    songs: [
      Song(
        title: 'Salamin, Salamin',
        artist: 'BINI',
        assetPath: 'assets/covers/salamin, salamin.jpg',
        mp3Path: 'assets/audio/salamin, salamin.mp3',
      ),
      Song(
        title: 'Pantropiko',
        artist: 'BINI',
        assetPath: 'assets/covers/pantropiko.jpg',
        mp3Path: 'assets/audio/pantropiko.mp3',
      ),
      Song(
        title: 'Karera',
        artist: 'BINI',
        assetPath: 'assets/covers/karera.jpg',
        mp3Path: 'assets/audio/karera.mp3',
      ),
      Song(
        title: 'Lagi',
        artist: 'BINI',
        assetPath: 'assets/covers/lagi.jpg',
        mp3Path: 'assets/audio/lagi.mp3',
      ),
      Song(
        title: 'Na Na Na',
        artist: 'BINI',
        assetPath: 'assets/covers/na na na.jpg',
        mp3Path: 'assets/audio/na_na_na.mp3',
      ),
      Song(
        title: 'Cherry On Top',
        artist: 'BINI',
        assetPath: 'assets/covers/cherry on top.jpg',
        mp3Path: 'assets/audio/cherry_on_top.mp3',
      ),
      // Add more songs here
    ],
  ),

  Album(
    title: 'This is Dionela',
    artist: 'Dionela',
    assetPath: 'assets/covers/dionela.jpg',
    songs: [
      Song(
        title: 'sining (feat. Jay R)',
        artist: 'Dionela',
        assetPath: 'assets/covers/sining.jpg',
        mp3Path: 'assets/audio/sining_feat_jay_r.mp3',
      ),
      Song(
        title: 'Hoodie (feat. Alisson Shore)',
        artist: 'Dionela',
        assetPath: 'assets/covers/hoodie.jpg',
        mp3Path: 'assets/audio/hoodie_feat_alisson_shore.mp3',
      ),
      Song(
        title: 'Musika',
        artist: 'Dionela',
        assetPath: 'assets/covers/musika.jpg',
        mp3Path: 'assets/audio/musika.mp3',
      ),
      Song(
        title: 'Oksihina',
        artist: 'Dionela',
        assetPath: 'assets/covers/oksihina.jpg',
        mp3Path: 'assets/audio/oksihina.mp3',
      ),
      Song(
        title: '153',
        artist: 'Dionela',
        assetPath: 'assets/covers/153.jpg',
        mp3Path: 'assets/audio/153.mp3',
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Maki',
    artist: 'Maki',
    assetPath: 'assets/covers/maki.jpg',
    songs: [
      Song(
        title: 'Dilaw',
        artist: 'Maki',
        assetPath: 'assets/covers/dilaw.jpg',
        mp3Path: 'assets/audio/dilaw.mp3',
      ),
      Song(
        title: 'Saan?',
        artist: 'Maki',
        assetPath: 'assets/covers/saan.jpg',
        mp3Path: 'assets/audio/saan.mp3',
      ),
      Song(
        title: 'Kailan?',
        artist: 'Maki',
        assetPath: 'assets/covers/kailan.jpg',
        mp3Path: 'assets/audio/kailan.mp3',
      ),
      Song(
        title: 'Sikulo',
        artist: 'Maki',
        assetPath: 'assets/covers/sikulo.jpg',
        mp3Path: 'assets/audio/sikulo.mp3',
      ),
      Song(
        title: 'Bakit?',
        artist: 'Maki',
        assetPath: 'assets/covers/bakit.jpg',
        mp3Path: 'assets/audio/bakit.mp3',
      ),
      // Add more songs here
    ],
  ),

  Album(
    title: 'This is Lola Amour',
    artist: 'Lola Amour',
    assetPath: 'assets/covers/lolaamour.png',
    songs: [
      Song(
        title: 'Raining In Manila',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/rain.png',
        mp3Path: 'assets/music/raining_in_manila.mp3', // Add MP3 path
      ),
      Song(
        title: 'Fallen',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/fallen.png',
        mp3Path: 'assets/music/fallen.mp3', // Add MP3 path
      ),
      Song(
        title: 'dahan-dahan',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/dahan.png',
        mp3Path: 'assets/music/dahan_dahan.mp3', // Add MP3 path
      ),
      Song(
        title: 'Pwede Ba',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/pwede.png',
        mp3Path: 'assets/music/pwede_ba.mp3', // Add MP3 path
      ),
      Song(
        title: 'Namimiss Ko Na',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/miss.png',
        mp3Path: 'assets/music/namimiss_ko_na.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Adie',
    artist: 'Adie',
    assetPath: 'assets/covers/adie.png',
    songs: [
      Song(
        title: 'Mahika',
        artist: 'Adie',
        assetPath: 'assets/covers/mahika.png',
        mp3Path: 'assets/music/mahika.mp3', // Add MP3 path
      ),
      Song(
        title: 'Tahanan',
        artist: 'Adie',
        assetPath: 'assets/covers/tahan.png',
        mp3Path: 'assets/music/tahanan.mp3', // Add MP3 path
      ),
      Song(
        title: 'Paraluman',
        artist: 'Adie',
        assetPath: 'assets/covers/paraluman.png',
        mp3Path: 'assets/music/paraluman.mp3', // Add MP3 path
      ),
      Song(
        title: 'Oh, Giliw',
        artist: 'Adie',
        assetPath: 'assets/covers/giliw.png',
        mp3Path: 'assets/music/oh_giliw.mp3', // Add MP3 path
      ),
      Song(
        title: 'Kursunada',
        artist: 'Adie',
        assetPath: 'assets/covers/kursunada.png',
        mp3Path: 'assets/music/kursunada.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is The 1975',
    artist: 'The 1975',
    assetPath: 'assets/covers/The 1975.jpeg',
    songs: [
      Song(
        title: 'About You',
        artist: 'The 1975',
        assetPath: 'assets/covers/About you.jpeg',
        mp3Path: 'assets/music/about_you.mp3', // Add MP3 path
      ),
      Song(
        title: 'Somebody Else',
        artist: 'The 1975',
        assetPath: 'assets/covers/Somebody Else.jpeg',
        mp3Path: 'assets/music/somebody_else.mp3', // Add MP3 path
      ),
      Song(
        title: 'Robbers',
        artist: 'The 1975',
        assetPath: 'assets/covers/Robbers.jpeg',
        mp3Path: 'assets/music/robbers.mp3', // Add MP3 path
      ),
      Song(
        title: 'Its Not Living If Its Not With You',
        artist: 'The 1975',
        assetPath: 'assets/covers/ItsNotLivingIfItsNotWithYou.jpeg',
        mp3Path: 'assets/music/its_not_living.mp3', // Add MP3 path
      ),
      Song(
        title: 'Chocolate',
        artist: 'The 1975',
        assetPath: 'assets/covers/Chocolate.jpeg',
        mp3Path: 'assets/music/chocolate.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Taylor Swift',
    artist: 'Taylor Swift',
    assetPath: 'assets/covers/Taylor Swift.jpg',
    songs: [
      Song(
        title: 'Fortnight (feat. Post Malone',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Fortnight feat. Post Malone.jpeg',
        mp3Path: 'assets/music/fortnight_feat_post_malone.mp3', // Add MP3 path
      ),
      Song(
        title: 'Cruel Summer',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Cruel Summer.jpeg',
        mp3Path: 'assets/music/cruel_summer.mp3', // Add MP3 path
      ),
      Song(
        title: 'I Can Do It With a Broken Heart',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/ICanDoItWithaBrokenHeart.jpeg',
        mp3Path:
            'assets/music/i_can_do_it_with_a_broken_heart.mp3', // Add MP3 path
      ),
      Song(
        title: 'Down Bad',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Down Bad.jpeg',
        mp3Path: 'assets/music/down_bad.mp3', // Add MP3 path
      ),
      Song(
        title: 'Guilty as Sin?',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Guilty as Sin.jpeg',
        mp3Path: 'assets/music/guilty_as_sin.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Cup Of Joe',
    artist: 'Cup of Joe',
    assetPath: 'assets/covers/cupofjoe.jpg',
    songs: [
      Song(
        title: 'Tingin',
        artist: 'Cup of Joe',
        assetPath: 'assets/covers/tingin.jpg',
        mp3Path: 'assets/audio/tingin.mp3',
      ),
      Song(
        title: 'Misteryoso',
        artist: 'Cup of Joe',
        assetPath: 'assets/covers/misteryo.jpg',
        mp3Path: 'assets/audio/misteryoso.mp3',
      ),
      Song(
        title: 'Estranghero',
        artist: 'Cup of Joe',
        assetPath: 'assets/covers/estranghero.jpg',
        mp3Path: 'assets/audio/estranghero.mp3',
      ),
      Song(
        title: 'Patutunguhan',
        artist: 'Cup of Joe',
        assetPath: 'assets/covers/patutunguhan.jpg',
        mp3Path: 'assets/audio/patutunguhan.mp3',
      ),
      Song(
        title: 'Ikaw Pa Rin Ang Pipiliin Ko',
        artist: 'Cup of Joe',
        assetPath: 'assets/covers/ikaw parin ang pipiliin ko.jpg',
        mp3Path: 'assets/audio/ikaw_pa_rin_ang_pipiliin_ko.mp3',
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Rhodessa',
    artist: 'Rhodessa',
    assetPath: 'assets/covers/rhodessa.jpg',
    songs: [
      Song(
        title: 'Kisame',
        artist: 'Rhodessa',
        assetPath: 'assets/covers/kisame.jpg',
        mp3Path: 'assets/audio/kisame.mp3',
      ),
      Song(
        title: 'pagod na (sayo)',
        artist: 'Rhodessa',
        assetPath: 'assets/covers/pagod na(sayo).jpg',
        mp3Path: 'assets/audio/pagod_na_sayo.mp3',
      ),
      Song(
        title: 'sa\'yong sa\'yo lang ako',
        artist: 'Rhodessa',
        assetPath: 'assets/covers/sa_yong sa_yo lang ako.jpg',
        mp3Path: 'assets/audio/sayong_sayo_lang_ako.mp3',
      ),
      Song(
        title: 'Mina(mahal ko)',
        artist: 'Rhodessa',
        assetPath: 'assets/covers/mina(mahal).jpg',
        mp3Path: 'assets/audio/mina_mahal_ko.mp3',
      ),
      Song(
        title: 'Isa, Dalawa, Tatlo',
        artist: 'Rhodessa',
        assetPath: 'assets/covers/isa, dalawa, tatlo.jpg',
        mp3Path: 'assets/audio/isa_dalawa_tatlo.mp3',
      ),
      // Add more songs here
    ],
  ),
  // Add more albums here
];
