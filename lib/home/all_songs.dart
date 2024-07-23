import 'package:flutter/material.dart';
import '../widget.dart';

class AllSongsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the data passed via RouteSettings
    final List<Album> albums =
        ModalRoute.of(context)!.settings.arguments as List<Album>;

    // Flatten the list of albums into a single list of songs
    final List<Song> allSongs = albums.expand((album) => album.songs).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Songs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: allSongs.length,
        itemBuilder: (context, index) {
          final song = allSongs[index];
          return ListTile(
            leading: Icon(Icons.music_note, color: Colors.white),
            title: Text(
              song.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song.artist,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Handle song tap if needed
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
