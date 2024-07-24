import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'widget.dart'; // Import your provider file

class MiniMediaPlayer extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onPlayPauseTap;
  final bool isFavorite;

  MiniMediaPlayer({
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    required this.onPlayPauseTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
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
            // Song Image
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
            // Song Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            // Controls
            IconButton(
              icon: FaIcon(
                isFavorite
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: isFavorite ? Color(0xff694F8E) : Colors.white,
                size: 24.0,
              ),
              onPressed: onFavoriteTap,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.play),
              onPressed: onPlayPauseTap,
              color: Colors.white,
              iconSize: 24.0,
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.ellipsisV),
              onPressed: onMoreOptionsTap,
              color: Colors.white,
              iconSize: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
