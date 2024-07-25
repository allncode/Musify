import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widget.dart'; // Import your Song class

class MiniMediaPlayer extends StatefulWidget {
  final Song? song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  MiniMediaPlayer({
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  _MiniMediaPlayerState createState() => _MiniMediaPlayerState();
}

class _MiniMediaPlayerState extends State<MiniMediaPlayer> {
  bool _isPlaying = false;

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
          Navigator.of(context).push(_createPageRoute());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.grey[900],
          ),
          height: 60,
          child: Row(
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
                  _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
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
        ),
      ),
    );
  }

  PageRouteBuilder _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ExpandedMediaPlayer(
          song: widget.song!,
          onTap: () {
            Navigator.of(context).pop();
          },
          onMoreOptionsTap: widget.onMoreOptionsTap,
          onFavoriteTap: widget.onFavoriteTap,
          onPlayPauseTap: widget.onPlayPauseTap,
          onPreviousTap: widget.onPreviousTap,
          onNextTap: widget.onNextTap,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

class ExpandedMediaPlayer extends StatefulWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  ExpandedMediaPlayer({
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  _ExpandedMediaPlayerState createState() => _ExpandedMediaPlayerState();
}

class _ExpandedMediaPlayerState extends State<ExpandedMediaPlayer> {
  double _sliderValue = 0.0; // Placeholder for the current song position
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  // bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Initialize song duration here if you have access to it
    _totalDuration = Duration(minutes: 3); // Example duration
  }

  void _updateSliderPosition() {
    // Update the slider position based on the current song progress
    setState(() {
      _sliderValue = _currentPosition.inSeconds.toDouble() /
          _totalDuration.inSeconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    final playbackNotifier = Provider.of<PlaybackNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          AppBar(
            title: Text(widget.song.title),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: widget.onMoreOptionsTap,
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(widget.song.assetPath, height: 200.0),
                  Text(widget.song.title,
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                  Text(widget.song.artist,
                      style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  Slider(
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        // Update song playback position here
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.redAccent,
                    inactiveColor: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: FaIcon(
                          favoritesNotifier.isFavorite(widget.song)
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: favoritesNotifier.isFavorite(widget.song)
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                        onPressed: () {
                          widget.onFavoriteTap();
                          // Optionally, update the favorite status directly here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white),
                        onPressed: widget.onPreviousTap,
                      ),
                      IconButton(
                        icon: Icon(
                          playbackNotifier.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          playbackNotifier.togglePlayback();
                          widget.onPlayPauseTap();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white),
                        onPressed: widget.onNextTap,
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        onPressed: widget.onTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
