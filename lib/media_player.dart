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

  const MiniMediaPlayer({
    Key? key,
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
  }) : super(key: key);

  @override
  _MiniMediaPlayerState createState() => _MiniMediaPlayerState();
}

class _MiniMediaPlayerState extends State<MiniMediaPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  void _updatePosition(Duration position) {
    setState(() {
      _position = position;
    });
  }

  void _seekTo(double value) async {
    final position = Duration(milliseconds: value.toInt());
    // Implement seeking logic
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.song != null) {
      _loadSong(widget.song!);
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

  @override
  void didUpdateWidget(covariant MiniMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.song != oldWidget.song) {
      if (widget.song != null) {
        _loadSong(widget.song!);
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
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    return widget.song == null
        ? SizedBox.shrink()
        : Container(
            color: Colors.black87,
            height: 60.0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        widget.song!.assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.song!.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.song!.artist,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _handlePlayPause,
                ),
                IconButton(
                  icon: FaIcon(
                    favoritesNotifier.isFavorite(widget.song!)
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: favoritesNotifier.isFavorite(widget.song!)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: widget.onFavoriteTap,
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: widget.onMoreOptionsTap,
                ),
              ],
            ),
          );
  }
}

class ExpandedMediaPlayer extends StatefulWidget {
  final Song song;
  final VoidCallback onClose;
  final VoidCallback onFavoriteTap;

  ExpandedMediaPlayer({
    required this.song,
    required this.onClose,
    required this.onFavoriteTap,
  });

  @override
  _ExpandedMediaPlayerState createState() => _ExpandedMediaPlayerState();
}

class _ExpandedMediaPlayerState extends State<ExpandedMediaPlayer> {
  @override
  void initState() {
    super.initState();
    final playbackNotifier =
        Provider.of<PlaybackNotifier>(context, listen: false);
    playbackNotifier.loadSong(widget.song); // Pass Song object
  }

  @override
  Widget build(BuildContext context) {
    final playbackNotifier = Provider.of<PlaybackNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.song.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    widget.song.assetPath,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.song.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                Text(
                  widget.song.artist,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20.0),
                IconButton(
                  icon: FaIcon(
                    Provider.of<FavoritesNotifier>(context)
                            .isFavorite(widget.song)
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Provider.of<FavoritesNotifier>(context)
                            .isFavorite(widget.song)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: widget.onFavoriteTap,
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_formatTime(playbackNotifier.position)}',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      Container(
                        width: 300.0,
                        child: Slider(
                          value: playbackNotifier.position.inMilliseconds
                              .toDouble(),
                          min: 0.0,
                          max: playbackNotifier.duration.inMilliseconds
                              .toDouble(),
                          onChanged: (value) {
                            playbackNotifier.seekTo(value);
                          },
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${_formatTime(playbackNotifier.duration)}',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.backward,
                          color: Colors.white),
                      onPressed: () {
                        // Implement previous track logic
                      },
                    ),
                    IconButton(
                      icon: FaIcon(
                        playbackNotifier.isPlaying
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        playbackNotifier._playPause();
                      },
                    ),
                    IconButton(
                      icon:
                          FaIcon(FontAwesomeIcons.forward, color: Colors.white),
                      onPressed: () {
                        // Implement next track logic
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

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class PlaybackNotifier extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  PlaybackNotifier() {
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
    });
  }

  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;

  Future<void> loadSong(Song song) async {
    Uri? uri = Uri.tryParse(song.mp3Path);

    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      // If the path is a URL
      await _audioPlayer.setSourceUrl(song.mp3Path);
    } else {
      // If the path is a local asset
      await _audioPlayer.setSource(AssetSource(song.mp3Path));
    }

    await _playPause();
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
