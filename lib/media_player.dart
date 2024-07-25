import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widget.dart'; // Import your Song class
import 'package:audioplayers/audioplayers.dart';

class MiniMediaPlayer extends StatefulWidget {
  final Song? song;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;

  MiniMediaPlayer({
    required this.song,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
  });

  @override
  _MiniMediaPlayerState createState() => _MiniMediaPlayerState();
}

class _MiniMediaPlayerState extends State<MiniMediaPlayer> {
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
  Widget build(BuildContext context) {
    if (widget.song == null) {
      return SizedBox.shrink(); // Return an empty widget if there's no song
    }

    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpandedMediaPlayer(
                song: widget.song!,
                onFavoriteTap: widget.onFavoriteTap,
                // onPlayPauseTap: widget.onPlayPauseTap,
                onClose: () {},
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.grey[900],
          ),
          height: 116, // Adjust the height to fit the new layout
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: Image.asset(
                      widget.song!.assetPath,
                      width: 70.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.song!.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          widget.song!.artist,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
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
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: FaIcon(
                      _isPlaying
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      widget.onPlayPauseTap();
                    },
                  ),
                ],
              ),
              SizedBox(height: 4.0), // Reduced space between Row and Slider
              Slider(
                value: _position.inMilliseconds.toDouble(),
                min: 0.0,
                max: _duration.inMilliseconds.toDouble(),
                onChanged: _seekTo,
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey[600],
              ),
            ],
          ),
        ),
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
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadSong();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _updatePosition(p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _nextTrack();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updatePosition(Duration position) {
    setState(() {
      this.position = position;
    });
  }

  void _seekTo(double value) async {
    final position = Duration(milliseconds: value.toInt());
    await _audioPlayer.seek(position);
  }

  void _loadSong() async {
    String songUrl = widget.song.mp3Path;
    print('Loading song from path: $songUrl'); // Ensure this path is correct
    try {
      await _audioPlayer.setSource(AssetSource(songUrl));
      _playPause(); // Update the playing state
    } catch (e) {
      print("Error loading song: $e");
    }
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextTrack() {
    // Implement next track logic if needed
  }

  void _previousTrack() {
    // Implement previous track logic if needed
  }

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.song.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [],
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
                IconButton(
                  icon: FaIcon(
                    favoritesNotifier.isFavorite(widget.song)
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: favoritesNotifier.isFavorite(widget.song)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: widget.onFavoriteTap,
                ),
                SizedBox(height: 20.0),
                Slider(
                  value: position.inMilliseconds.toDouble(),
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: _seekTo,
                  activeColor: Colors.redAccent,
                  inactiveColor: Colors.grey[600],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.backward,
                          color: Colors.white),
                      onPressed: _previousTrack,
                    ),
                    IconButton(
                      icon: FaIcon(
                        isPlaying
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                      ),
                      onPressed: _playPause,
                    ),
                    IconButton(
                      icon:
                          FaIcon(FontAwesomeIcons.forward, color: Colors.white),
                      onPressed: _nextTrack,
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
}

class PlaybackNotifier extends ChangeNotifier {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void togglePlayback() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }
}
