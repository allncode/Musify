import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget.dart'; // Adjust the import according to your file structure
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song> _allSongs = [];
  List<Album> _allAlbums = [];
  List<dynamic> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _allSongs = _getAllSongsFromAlbums();
    _allAlbums = albums; // Get all albums from the main.dart
    _filteredResults = _allSongs; // Initialize with all songs
  }

  List<Song> _getAllSongsFromAlbums() {
    List<Song> allSongs = [];
    for (Album album in albums) {
      allSongs.addAll(album.songs);
    }
    return allSongs;
  }

  void _filterResults(String query) {
    setState(() {
      _filteredResults = [
        ..._allSongs.where((song) {
          final titleLower = song.title.toLowerCase();
          final artistLower = song.artist.toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower) ||
              artistLower.contains(queryLower);
        }).toList(),
        ..._allAlbums.where((album) {
          final titleLower = album.title.toLowerCase();
          final artistLower = album.artist.toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower) ||
              artistLower.contains(queryLower);
        }).toList(),
      ];
    });
  }

  void _handleSongTap(Song song) {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);
    favoritesNotifier.setCurrentSong(song);
    Navigator.pop(context); // Close the search screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: _filterResults,
            ),
            SizedBox(height: 20.0),
            Text(
              'Search Results',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: _filteredResults.map((result) {
                  if (result is Song) {
                    return _buildSearchResultCard(
                        result.title, result.artist, result.assetPath,
                        isSong: true, song: result);
                  } else if (result is Album) {
                    return _buildSearchResultCard(
                        result.title, result.artist, result.assetPath,
                        isSong: false);
                  } else {
                    return SizedBox.shrink(); // Handle unexpected cases
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(String title, String artist, String assetPath,
      {required bool isSong, Song? song}) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(assetPath),
          radius: 30.0,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          artist,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: isSong
            ? Consumer<FavoritesNotifier>(
                builder: (context, favoritesNotifier, child) {
                  bool isFavorite =
                      song != null && favoritesNotifier.isFavorite(song);

                  return IconButton(
                    icon: Icon(
                      isFavorite
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: isFavorite ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        favoritesNotifier.removeSong(song!);
                      } else {
                        favoritesNotifier.addSong(song!);
                      }
                    },
                  );
                },
              )
            : null,
        onTap: () {
          if (isSong) {
            final song = _allSongs.firstWhere(
              (song) => song.title == title && song.artist == artist,
            );
            _handleSongTap(song);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AlbumDetailScreen(
                  title: title,
                  artist: artist,
                  assetPath: assetPath,
                  songs: _allAlbums
                      .firstWhere((album) => album.title == title)
                      .songs,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
