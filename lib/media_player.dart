import 'package:flutter/material.dart';
import 'widget.dart';

class MiniMediaPlayer extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap; // Callback for the 3-dots icon
  final VoidCallback onFavoriteTap; // Callback for the heart icon

  const MiniMediaPlayer({
    required this.song,
    required this.onTap,
    required this.onMoreOptionsTap,
    required this.onFavoriteTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Adjust color if needed
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  song.assetPath,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0), // Adjust spacing as needed
                  Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border,
                    color: Colors.white), // Heart icon
                onPressed: onFavoriteTap,
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white), // 3-dots icon
                onPressed: onMoreOptionsTap,
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
