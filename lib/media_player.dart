import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget.dart'; // Import your Song class

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
      return SizedBox.shrink(); // Return an empty widget if no song is selected
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[900],
        ),
        height: 80,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Image.asset(
                song.assetPath,
                width: 70.0,
                height: 80.0,
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
            // Controls for play/pause, favorite, and more options
            IconButton(
              icon: Icon(
                favoritesNotifier.isFavorite(song)
                    ? Icons.favorite
                    : Icons.favorite_border,
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
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                // Handle play/pause tap
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Handle more options tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
