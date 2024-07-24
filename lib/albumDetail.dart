import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget.dart'; // Ensure you have MiniMediaPlayer and FavoritesNotifier defined in this file

class AlbumDetailScreen extends StatefulWidget {
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
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  widget.assetPath,
                  width: double.infinity,
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.artist,
                        style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Songs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.songs.length,
                        itemBuilder: (context, index) {
                          final song = widget.songs[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                song.assetPath,
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(song.title,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(song.artist,
                                style: TextStyle(color: Colors.grey)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.play_arrow,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Handle play button press
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.white),
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
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.info),
                                              title: Text('Song Info'),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.share),
                                              title: Text('Share'),
                                              onTap: () {
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
        ],
      ),
    );
  }
}
