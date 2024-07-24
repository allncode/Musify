import 'package:flutter/material.dart';
import 'widget.dart'; // Ensure you have MiniMediaPlayer defined in this file

class AlbumDetailScreen extends StatelessWidget {
  final String title;
  final String artist;
  final String assetPath;
  final List<Song> songs;

  const AlbumDetailScreen({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff694F8E)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(assetPath,
                width: double.infinity, height: 300.0, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                  Text(artist,
                      style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  SizedBox(height: 16.0),
                  Text('Songs',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(song.assetPath,
                              height: 50.0, width: 50.0, fit: BoxFit.cover),
                        ),
                        title: Text(song.title,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(song.artist,
                            style: TextStyle(color: Colors.grey)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () {
                                // Handle play button press
                                // For example, you could update a state or navigate to a detailed player screen
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {
                                // Show options
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.add),
                                          title: Text('Add to Playlist'),
                                          onTap: () {
                                            // Handle add to playlist
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.info),
                                          title: Text('Song Info'),
                                          onTap: () {
                                            // Handle song info
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.share),
                                          title: Text('Share'),
                                          onTap: () {
                                            // Handle share
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Optionally handle song tap
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
