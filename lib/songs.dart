import 'package:flutter/material.dart';

class Song {
  final String title;
  final String artist;
  final String assetPath;
  final String mp3Path; // New field for MP3 file path

  Song({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.mp3Path, // Initialize new field
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
