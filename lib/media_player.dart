import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MiniMediaPlayer extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;

  MiniMediaPlayer({
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);
    final Song? song = favoritesNotifier.currentSong;

    if (song == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                song.assetPath,
                width: 70.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    song.artist,
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
                favoritesNotifier.isFavorite(song)
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: favoritesNotifier.isFavorite(song)
                    ? Colors.redAccent
                    : Colors.white,
              ),
              onPressed: () {
                if (favoritesNotifier.isFavorite(song)) {
                  favoritesNotifier.removeSong(song);
                } else {
                  favoritesNotifier.addSong(song);
                }
              },
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.play,
                color: Colors.white,
              ),
              onPressed: onPlayPauseTap,
            ),
          ],
        ),
      ),
    );
  }
}
