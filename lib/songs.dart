import 'package:flutter/material.dart';

class Song {
  final String title;
  final String artist;
  final String assetPath;

  Song({
    required this.title,
    required this.artist,
    required this.assetPath,
  });
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
}
