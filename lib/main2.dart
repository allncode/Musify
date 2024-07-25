import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'widget.dart';

class MySpotify extends StatefulWidget {
  const MySpotify({super.key});

  @override
  State<MySpotify> createState() => _MySpotifyState();
}

class _MySpotifyState extends State<MySpotify> {
  int _selectedIndex = 0;
  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // For Home
    GlobalKey<NavigatorState>(), // For Search
    GlobalKey<NavigatorState>(), // For Your Library
    GlobalKey<NavigatorState>(), // For Liked Songs
  ];

  final PageController _pageController = PageController();
  List<dynamic> recentlyViewed = [];
  Song? _currentSong;
  List<Song> recentlyPlayed = [];
  bool _isPlaying = false;
  ///////////////////////////////////////////////////////////////////////
  final List<Widget> _pages = [
    // other pages here
    LikedSongs(),
  ];
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadSong();
    await _loadFavorites();
    await _loadRecentlyPlayed();
    await _loadRecentlyViewed();
  }

  Future<void> _loadSong() async {
    _currentSong = await loadCurrentSong();
    setState(() {});
  }

  Future<void> _loadFavorites() async {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);
    await favoritesNotifier.loadFavorites();
  }

  Future<void> _loadRecentlyPlayed() async {
    final recentlyPlayedNotifier =
        Provider.of<RecentlyPlayedNotifier>(context, listen: false);
    await recentlyPlayedNotifier.loadRecentlyPlayed();
    setState(() {
      recentlyPlayed = recentlyPlayedNotifier.recentlyPlayed;
    });
  }

  Future<void> _loadRecentlyViewed() async {
    final recentlyViewedNotifier =
        Provider.of<RecentlyViewedNotifier>(context, listen: false);
    await recentlyViewedNotifier.loadRecentlyViewed();
    print('Loaded Recently Viewed: ${recentlyViewedNotifier.recentlyViewed}');
    setState(() {
      recentlyViewed = recentlyViewedNotifier.recentlyViewed;
    });
  }

  Future<void> _onUserLogin(String newUserId) async {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);
    final recentlyPlayedNotifier =
        Provider.of<RecentlyPlayedNotifier>(context, listen: false);
    final recentlyViewedNotifier =
        Provider.of<RecentlyViewedNotifier>(context, listen: false);

    favoritesNotifier.setUserId(newUserId);
    recentlyPlayedNotifier.setUserId(newUserId);
    recentlyViewedNotifier.setUserId(newUserId);

    // Reload data
    await _loadFavorites();
    await _loadRecentlyPlayed();
    await _loadRecentlyViewed();
  }

  Future<void> _loginUser(String userId) async {
    // Perform login actions

    // After login, load user-specific data
    await _onUserLogin(userId);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  Future<void> _addToRecentlyViewed(dynamic item) async {
    final recentlyViewedNotifier =
        Provider.of<RecentlyViewedNotifier>(context, listen: false);

    if (item is Album) {
      // Update the RecentlyViewedNotifier with the new album
      recentlyViewedNotifier.addAlbum(item);

      // Update the UI to reflect changes
      setState(() {
        // Directly use the updated list from the notifier
        recentlyViewed = recentlyViewedNotifier.recentlyViewed;
      });
    }
  }

  Future<void> _addToRecentlyPlayed(Song song) async {
    final recentlyPlayedNotifier =
        Provider.of<RecentlyPlayedNotifier>(context, listen: false);
    await recentlyPlayedNotifier.addSong(song);
    setState(() {
      recentlyPlayed = recentlyPlayedNotifier.recentlyPlayed;
    });
  }

  List<Song> _getAllSongsFromAlbums() {
    List<Song> allSongs = [];
    for (Album album in albums) {
      allSongs.addAll(album.songs);
    }
    return allSongs;
  }

  void _handleFavoriteTap() {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);

    if (_currentSong != null && favoritesNotifier.isFavorite(_currentSong!)) {
      favoritesNotifier.removeSong(_currentSong!);
    } else {
      favoritesNotifier.addSong(_currentSong!);
    }

    // Update the state after changing favorite status
    setState(() {
      _currentSong = favoritesNotifier.currentSong;
    });
  }

  void _handlePlayPauseTap() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _handleSongTap(Song song) {
    final favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: false);

    favoritesNotifier.setCurrentSong(song);

    setState(() {
      _currentSong = song;
      _isPlaying = true;
      _addToRecentlyPlayed(song); // Add to recently played when song is tapped
    });
  }

  void _handleGridItemTap() {
    _navigatorKeys[_selectedIndex].currentState?.push(
          MaterialPageRoute(
            builder: (context) => LikedSongs(),
          ),
        );
  }

  Future<void> saveCurrentSong(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    final songJson = jsonEncode(song.toJson());
    await prefs.setString('currentSong', songJson);
  }

  Future<Song?> loadCurrentSong() async {
    final prefs = await SharedPreferences.getInstance();
    final songJson = prefs.getString('currentSong');
    if (songJson != null) {
      final songMap = jsonDecode(songJson);
      return Song.fromJson(songMap);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                Navigator(
                  key: _navigatorKeys[0],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => _buildMusicPage(),
                    );
                  },
                ),
                Navigator(
                  key: _navigatorKeys[1],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    );
                  },
                ),
                Navigator(
                  key: _navigatorKeys[2],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => MyLibrary(),
                    );
                  },
                ),
                Navigator(
                  key: _navigatorKeys[3],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => LikedSongs(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xff694F8E),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Your Library',
            ),
          ],
          onTap: _onItemTapped,
        ),
        persistentFooterButtons: [
          Consumer<FavoritesNotifier>(
            builder: (context, favoritesNotifier, child) {
              return MiniMediaPlayer(
                song: favoritesNotifier.currentSong,
                // onTap: () {}, // Provide your own callback if needed
                onMoreOptionsTap: () {}, // Provide your own callback if needed
                onFavoriteTap:
                    _handleFavoriteTap, // Callback for favorite button
                onPlayPauseTap:
                    _handlePlayPauseTap, // Callback for play/pause button
              );
            },
          )
        ]);
  }

  Widget _buildMusicPage() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Music',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // Use the Navigator corresponding to the current index
                    _navigatorKeys[_selectedIndex].currentState?.push(
                          MaterialPageRoute(builder: (context) => LikedSongs()),
                        );
                  },
                  child: _buildSongCard(
                    context,
                    'Liked Songs',
                    'assets/images/heart.png',
                    Color(0xff694F8E),
                    LikedSongs(),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Popular albums',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: albums.map((album) {
                  return GestureDetector(
                    onTap: () => _handleAlbumTap(album),
                    child: _buildAlbumCard(album),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Songs',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 180.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _getAllSongsFromAlbums().map((song) {
                  return GestureDetector(
                    onTap: () => _handleSongTap(song),
                    child: _buildSongCardForListView(song),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30.0),
            if (recentlyViewed.isNotEmpty) ...[
              Text(
                'Recently Viewed',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 170.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: recentlyViewed.map((album) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AlbumDetailScreen(
                              title: album.title,
                              artist: album.artist,
                              assetPath: album.assetPath,
                              songs: album.songs,
                            ),
                          ),
                        );
                      },
                      child: _buildAlbumCard(album),
                    );
                  }).toList(),
                ),
              ),
            ],
            SizedBox(height: 30.0),
            if (recentlyPlayed.isNotEmpty) ...[
              Text(
                'Recently Played Songs',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 180.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: recentlyPlayed.reversed.map((song) {
                    return _buildSongCardForListView(song);
                  }).toList(),
                ),
              ),
              SizedBox(height: 50),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSongCardForListView(Song song) {
    return GestureDetector(
      onTap: () {
        final playerNotifier =
            Provider.of<FavoritesNotifier>(context, listen: false);
        playerNotifier.setCurrentSong(song);
        _addToRecentlyPlayed(song);
        setState(() {
          _currentSong = song;
        });
      },
      child: Container(
        width: 120.0,
        height: 200.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                song.assetPath,
                height: 120.0,
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              song.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0),
            ),
            Text(
              song.artist,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongCard(BuildContext context, String title, String imagePath,
      Color backgroundColor, Widget screen) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        padding: EdgeInsets.only(right: 12.0),
        height: 60.0,
        child: Row(
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 60.0,
              height: 65.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            // Optional: You can add an icon or another widget here if needed
          ],
        ),
      ),
    );
  }

  void _handleAlbumTap(Album album) {
    // Use the correct Navigator key for the selected page
    _navigatorKeys[_selectedIndex].currentState?.push(
          MaterialPageRoute(
            builder: (context) => AlbumDetailScreen(
              title: album.title,
              artist: album.artist,
              assetPath: album.assetPath,
              songs: album.songs,
            ),
          ),
        );
  }

  Widget _buildAlbumCard(Album album) {
    return GestureDetector(
      onTap: () {
        _addToRecentlyViewed(album);
        _handleAlbumTap(album);
      },
      child: Container(
        width: 150.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Image.asset(
                album.assetPath,
                height: 200.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(1),
                          offset: Offset(0.5, 0.5),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    album.artist,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(1),
                          offset: Offset(0, 0),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextTap() {}

  void _handlePreviousTap() {}
}
