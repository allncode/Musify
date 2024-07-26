import 'package:flutter/material.dart';
import 'widget.dart'; // Import the Album model

class LibraryNotifier extends ChangeNotifier {
  List<Album> _albums = [];

  List<Album> get albums => _albums;

  void addAlbum(Album album) {
    _albums.add(album);
    notifyListeners();
  }
}
