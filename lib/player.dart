import 'package:flutter/foundation.dart';
import 'widget.dart';

class PlayerState extends ChangeNotifier {
  Song? _currentSong;

  Song? get currentSong => _currentSong;

  void setCurrentSong(Song? song) {
    _currentSong = song;
    notifyListeners();
  }
}
