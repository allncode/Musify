import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/splash_screen.dart';
import 'package:myapp/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffB692C2)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const MySplashScreen(),
      routes: {
        '/search': (context) => SearchScreen(),
        '/your_library': (context) => YourLibrary(),
        '/likesSongs': (context) => LikedSongs(),
      },
    );
  }
}

class MySpotify extends StatefulWidget {
  const MySpotify({super.key});

  @override
  State<MySpotify> createState() => _MySpotifyState();
}

class _MySpotifyState extends State<MySpotify> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  final PageController _pageController = PageController();
  List<Map<String, String>> recentlyViewed = [];
  Song? _currentSong;
  List<Song> recentlyPlayed = [];
  bool _isPlaying = false;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // If the user taps the tab bar item twice, it should pop to the first route
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _addToRecentlyViewed(String title, String artist, String assetPath) {
    setState(() {
      final newEntry = {
        'title': title,
        'artist': artist,
        'assetPath': assetPath,
      };

      final existingIndex = recentlyViewed.indexWhere((entry) =>
          entry['title'] == title &&
          entry['artist'] == artist &&
          entry['assetPath'] == assetPath);

      if (existingIndex != -1) {
        recentlyViewed.removeAt(existingIndex);
      }

      recentlyViewed.add(newEntry);

      if (recentlyViewed.length > 5) {
        recentlyViewed.removeAt(0);
      }

      _saveRecentlyViewed(); // Save to SharedPreferences
    });
  }

  void _addToRecentlyPlayed(Song song) {
    setState(() {
      if (!recentlyPlayed.contains(song)) {
        recentlyPlayed.add(song);
        if (recentlyPlayed.length > 5) {
          recentlyPlayed.removeAt(0);
        }
      }

      _saveRecentlyPlayed(); // Save to SharedPreferences
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

    if (favoritesNotifier.isFavorite(_currentSong!)) {
      favoritesNotifier.removeSong(_currentSong!);
    } else {
      favoritesNotifier.addSong(_currentSong!);
    }

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
    });
  }

  void _handleGridItemTap() {
    _navigatorKeys[_selectedIndex].currentState?.push(
          MaterialPageRoute(
            builder: (context) => LikedSongs(),
          ),
        );
  }

  Future<void> _saveRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedList = recentlyViewed.map((entry) => entry.toString()).toList();
    await prefs.setStringList('recentlyViewed', viewedList);
  }

  Future<void> _saveRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final playedList =
        recentlyPlayed.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('recentlyPlayed', playedList);
  }

  Future<void> _loadRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedList = prefs.getStringList('recentlyViewed') ?? [];
    setState(() {
      recentlyPlayed = viewedList
          .map((songJson) => Song.fromJson(jsonDecode(songJson)))
          .toList();
    });
  }

  Future<void> _loadRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final playedList = prefs.getStringList('recentlyPlayed') ?? [];
    setState(() {
      recentlyPlayed = playedList
          .map((songJson) => Song.fromJson(jsonDecode(songJson)))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecentlyViewed();
    _loadRecentlyPlayed();
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                    builder: (context) => YourLibrary(),
                  );
                },
              ),
            ],
          ),
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
              onTap: () {},
              onMoreOptionsTap: () {},
              onFavoriteTap: _handleFavoriteTap,
              onPlayPauseTap: _handlePlayPauseTap,
            );
          },
        ),
      ],
    );
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
                  onTap: _handleGridItemTap,
                  child: _buildSongCard(
                      context,
                      'Liked Songs',
                      'assets/images/heart.png',
                      Color(0xff694F8E),
                      LikedSongs()),
                ),
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
                  return _buildAlbumCard(album);
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
                    onTap: () {
                      setState(() {
                        _currentSong = song;
                      });
                    },
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
                  children: recentlyViewed.reversed.map((viewedItem) {
                    if (viewedItem.containsKey('assetPath') &&
                        viewedItem.containsKey('title') &&
                        viewedItem.containsKey('artist')) {
                      // Handle album
                      final album = Album(
                        title: viewedItem['title']!,
                        artist: viewedItem['artist']!,
                        assetPath: viewedItem['assetPath']!,
                        songs: albums
                            .firstWhere(
                                (album) => album.title == viewedItem['title']!)
                            .songs,
                      );
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
                    } else {
                      // Handle song
                      final song = Song(
                        title: viewedItem['title']!,
                        artist: viewedItem['artist']!,
                        assetPath: viewedItem['assetPath']!,
                        mp3Path: viewedItem['mp3Path']!,
                      );
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSong = song;
                          });
                        },
                        child: _buildSongCardForListView(song),
                      );
                    }
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
        _addToRecentlyViewed(album.title, album.artist, album.assetPath);
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

  void _showBottomSheet(BuildContext context, Album album) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circlePlus, color: Colors.white),
            title:
                Text('Add to Library', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _handleMenuSelection('Option2', album);
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circleInfo, color: Colors.white),
            title: Text('Song Details', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _handleMenuSelection('Option3', album);
            },
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value, Album album) {
    switch (value) {
      case 'Option1':
        // Handle Option 1 action
        break;
      case 'Option2':
        // Handle Option 2 action
        break;
      case 'Option3':
        // Handle Option 3 action
        break;
      default:
        // Handle default case
        break;
    }
  }
}
