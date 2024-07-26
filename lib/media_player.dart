import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'widget.dart';

class MiniMediaPlayer extends StatefulWidget {
  final Song? song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onNextTap;
  final VoidCallback onPrevTap;

  const MiniMediaPlayer({
    Key? key,
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
    required this.onNextTap,
    required this.onPrevTap,
  }) : super(key: key);

  @override
  _MiniMediaPlayerState createState() => _MiniMediaPlayerState();
}

class _MiniMediaPlayerState extends State<MiniMediaPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isFavorite = false;
  Duration _songDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.song != null) {
      _loadSong(widget.song!);
      _updateFavoriteStatus();
    }
  }

  Future<void> _loadSong(Song song) async {
    Uri? uri = Uri.tryParse(song.mp3Path);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      await _audioPlayer.setSourceUrl(song.mp3Path);
    } else {
      await _audioPlayer.setSource(AssetSource(song.mp3Path));
    }

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _songDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.resume();
  }

  void _handlePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _handleNext() {
    widget.onNextTap();
    if (widget.song != null) {
      _loadSong(widget.song!);
    }
  }

  void _handlePrev() {
    widget.onPrevTap();
    if (widget.song != null) {
      _loadSong(widget.song!);
    }
  }

  void _updateFavoriteStatus() {
    // Replace with actual logic to check if the song is favorite
    setState(() {
      _isFavorite = Provider.of<FavoritesNotifier>(context, listen: false)
          .isFavorite(widget.song!);
    });
  }

  @override
  void didUpdateWidget(covariant MiniMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.song != oldWidget.song) {
      if (widget.song != null) {
        _loadSong(widget.song!);
        _updateFavoriteStatus();
      } else {
        _audioPlayer.stop();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.song == null
        ? SizedBox.shrink()
        : Container(
            color: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 100.0,
            child: Row(
              children: [
                // Image Container
                Container(
                  width: 80.0,
                  height: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      widget.song!.assetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                // Song Details and Duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.song!.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.0), // Add some spacing
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 60.0, // Adjust max width as needed
                            ),
                            child: Text(
                              _formatDuration(_songDuration),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.song!.artist,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _formatDuration(_currentPosition),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      // Controls Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            onPressed: _handlePrev,
                          ),
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            onPressed: _handlePlayPause,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            onPressed: _handleNext,
                          ),
                          IconButton(
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  _isFavorite ? Colors.redAccent : Colors.white,
                              size: 24.0,
                            ),
                            onPressed: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                              widget.onFavoriteTap();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class PlaybackNotifier extends ChangeNotifier with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  List<Song> _playlist = [];
  int _currentIndex = -1;

  PlaybackNotifier() {
    WidgetsBinding.instance?.addObserver(this);

    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      notifyListeners();
      _playNext(); // Automatically play next song when current completes
    });
  }

  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  Future<void> loadSong(Song song) async {
    Uri? uri = Uri.tryParse(song.mp3Path);

    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      // If the path is a URL
      await _audioPlayer.setSourceUrl(song.mp3Path);
    } else {
      // If the path is a local asset
      await _audioPlayer.setSource(AssetSource(song.mp3Path));
    }

    if (!_isPlaying) {
      await _playPause();
    }
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer
          .resume(); // Use resume to continue playing after pausing
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  Future<void> seekTo(double value) async {
    final position = Duration(milliseconds: value.toInt());
    await _audioPlayer.seek(position);
    _position = position;
    notifyListeners();
  }

  void _playNext() {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      loadSong(_playlist[_currentIndex]);
    }
  }

  void _playPrevious() {
    if (_playlist.isNotEmpty) {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      loadSong(_playlist[_currentIndex]);
    }
  }

  Future<void> setPlaylist(List<Song> playlist) async {
    _playlist = playlist;
    _currentIndex = 0;
    if (_playlist.isNotEmpty) {
      await loadSong(_playlist[_currentIndex]);
    }
  }

  Future<void> addSongToPlaylist(Song song) async {
    _playlist.add(song);
    if (_currentIndex == -1) {
      _currentIndex = 0;
      await loadSong(_playlist[_currentIndex]);
    }
  }

  void playNext() {
    _playNext();
  }

  void playPrevious() {
    _playPrevious();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stopPlayback();
    }
  }

  Future<void> _stopPlayback() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
}


// class ExpandedMediaPlayer extends StatefulWidget {
//   final Song song;
//   final VoidCallback onClose;
//   final VoidCallback onFavoriteTap;

//   ExpandedMediaPlayer({
//     required this.song,
//     required this.onClose,
//     required this.onFavoriteTap,
//   });

//   @override
//   _ExpandedMediaPlayerState createState() => _ExpandedMediaPlayerState();
// }

// class _ExpandedMediaPlayerState extends State<ExpandedMediaPlayer> {
//   @override
//   void initState() {
//     super.initState();
//     final playbackNotifier =
//         Provider.of<PlaybackNotifier>(context, listen: false);
//     playbackNotifier.loadSong(widget.song); // Pass Song object
//   }

//   @override
//   Widget build(BuildContext context) {
//     final playbackNotifier = Provider.of<PlaybackNotifier>(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         title: Text(widget.song.title),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: widget.onClose,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.asset(
//                     widget.song.assetPath,
//                     width: 150.0,
//                     height: 150.0,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Text(
//                   widget.song.title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24.0,
//                   ),
//                 ),
//                 Text(
//                   widget.song.artist,
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 16.0,
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 IconButton(
//                   icon: FaIcon(
//                     Provider.of<FavoritesNotifier>(context)
//                             .isFavorite(widget.song)
//                         ? FontAwesomeIcons.solidHeart
//                         : FontAwesomeIcons.heart,
//                     color: Provider.of<FavoritesNotifier>(context)
//                             .isFavorite(widget.song)
//                         ? Colors.redAccent
//                         : Colors.white,
//                   ),
//                   onPressed: widget.onFavoriteTap,
//                 ),
//                 SizedBox(height: 20.0),
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '${_formatTime(playbackNotifier.position)}',
//                         style: TextStyle(color: Colors.grey, fontSize: 12.0),
//                       ),
//                       Container(
//                         width: 300.0,
//                         child: Slider(
//                           value: playbackNotifier.position.inMilliseconds
//                               .toDouble(),
//                           min: 0.0,
//                           max: playbackNotifier.duration.inMilliseconds
//                               .toDouble(),
//                           onChanged: (value) {
//                             playbackNotifier.seekTo(value);
//                           },
//                           activeColor: Colors.redAccent,
//                           inactiveColor: Colors.grey[600],
//                         ),
//                       ),
//                       Text(
//                         '${_formatTime(playbackNotifier.duration)}',
//                         style: TextStyle(color: Colors.grey, fontSize: 12.0),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: FaIcon(FontAwesomeIcons.backward,
//                           color: Colors.white),
//                       onPressed: () {
//                         // Implement previous track logic
//                       },
//                     ),
//                     IconButton(
//                       icon: FaIcon(
//                         playbackNotifier.isPlaying
//                             ? FontAwesomeIcons.pause
//                             : FontAwesomeIcons.play,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         playbackNotifier._playPause();
//                       },
//                     ),
//                     IconButton(
//                       icon:
//                           FaIcon(FontAwesomeIcons.forward, color: Colors.white),
//                       onPressed: () {
//                         // Implement next track logic
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(Duration duration) {
//     final minutes = duration.inMinutes;
//     final seconds = duration.inSeconds % 60;
//     return '$minutes:${seconds.toString().padLeft(2, '0')}';
//   }
// }
