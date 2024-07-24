import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song> _allSongs = [];
  List<Album> _allAlbums = [];
  List<dynamic> _filteredResults = [];
  Song? _currentSong;

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

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

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
                      title: result.title,
                      artist: result.artist,
                      assetPath: result.assetPath,
                      isSong: true,
                      song: result,
                      favoritesProvider: favoritesProvider,
                    );
                  } else if (result is Album) {
                    return _buildSearchResultCard(
                      title: result.title,
                      artist: result.artist,
                      assetPath: result.assetPath,
                      isSong: false,
                    );
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

  Widget _buildSearchResultCard({
    required String title,
    required String artist,
    required String assetPath,
    required bool isSong,
    Song? song,
    FavoritesProvider? favoritesProvider,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8.0),
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
            ? IconButton(
                icon: Icon(
                  favoritesProvider != null &&
                          favoritesProvider.isFavorite(song!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  if (song != null) {
                    favoritesProvider?.toggleFavorite(song);
                  }
                },
              )
            : null,
        onTap: () {
          if (isSong && song != null) {
            _showMiniMediaPlayer(context, song);
          } else if (!isSong) {
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

  void _showMiniMediaPlayer(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MiniMediaPlayer(
          song: song,
          onTap: () {
            // Handle song tap in MiniMediaPlayer
          },
          onMoreOptionsTap: () {
            // Handle more options tap
          },
          onPlayPauseTap: () {
            // Handle play/pause
          },
          onFavoriteTap: () {
            final favoritesProvider =
                Provider.of<FavoritesProvider>(context, listen: false);
            favoritesProvider.toggleFavorite(song);
          },
          isFavorite: Provider.of<FavoritesProvider>(context).isFavorite(song),
        );
      },
    );
  }
}
