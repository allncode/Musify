import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  final String title;
  final String artist;
  final String assetPath;

  PhotoCard({
    required this.title,
    required this.artist,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            height: 200.0,
            width: 200.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            artist,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
