import 'package:flutter/material.dart';
import 'widget.dart';

class MiniMediaPlayer extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;
  final VoidCallback onFavoriteTap;

  const MiniMediaPlayer({
    Key? key,
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        children: [
          // Your existing widgets for song display
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  song.assetPath,
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                song.title,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                song.artist,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: onTap,
            ),
          ),
          IconButton(
            icon: Icon(
              Favorites.isFavorite(song)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: onFavoriteTap,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: onMoreOptionsTap,
          ),
        ],
      ),
    );
  }
}
