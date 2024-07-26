import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget.dart'; // Import the Album model

class MyLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Library'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LibraryNotifier>(
        builder: (context, libraryNotifier, child) {
          return ListView(
            children: [
              ListTile(
                leading: Image.asset('assets/images/heart.png',
                    width: 50, height: 50),
                title:
                    Text('My Favorites', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to My Favorites page or handle tap
                },
              ),
              ...libraryNotifier.albums.map((album) {
                return ListTile(
                  leading: Image.asset(album.assetPath, width: 50, height: 50),
                  title:
                      Text(album.title, style: TextStyle(color: Colors.white)),
                  subtitle:
                      Text(album.artist, style: TextStyle(color: Colors.grey)),
                );
              }).toList(),
            ],
          );
        },
      ),
      backgroundColor: Colors.black, // Spotify-like background color
    );
  }
}
