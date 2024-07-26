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
  void _playSong(Song song) {
    // Logic to play the song (e.g., play the song using an audio player)
  }

  void _handleSongTap(Song song) {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);

    // Update the currently playing song in the provider
    favoritesNotifier.setCurrentSong(song);

    // Optionally, you can also play the song
    _playSong(song);
  }

  void _showSimpleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.add, color: Colors.white),
            title:
                Text('Add to Library', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Your action here
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('Song Details', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Your action here
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = Provider.of<FavoritesNotifier>(context);

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
                                    _handleSongTap(song);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.white),
                                  onPressed: () {
                                    _showSimpleBottomSheet(context);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              _handleSongTap(song);
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
