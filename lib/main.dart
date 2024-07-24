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
    });
  }

  void _addToRecentlyPlayed(Song song) {
    // Add this method
    setState(() {
      if (!recentlyPlayed.contains(song)) {
        recentlyPlayed.add(song);
        if (recentlyPlayed.length > 5) {
          recentlyPlayed.removeAt(0);
        }
      }
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
    if (_currentSong != null) {
      if (Favorites.isFavorite(_currentSong!)) {
        Favorites.removeSong(_currentSong!);
      } else {
        Favorites.addSong(_currentSong!);
      }
      setState(() {}); // Refresh the MiniMediaPlayer to reflect the change
    }
  }

  void _handlePlayPauseTap() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
                    builder: (context) => YourLibrary(),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _currentSong != null
                ? MiniMediaPlayer(
                    song: _currentSong!,
                    onTap: () {
                      // Handle the play button tap
                    },
                    onMoreOptionsTap: () {
                      // Handle the three-dots icon tap
                    },
                    onFavoriteTap: _handleFavoriteTap,
                    onPlayPauseTap: _handlePlayPauseTap,
                  )
                : SizedBox.shrink(),
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
                _buildSongCard(
                  context,
                  'Liked Songs',
                  'images/assets/heart.png',
                  Color(0xff694F8E),
                  LikedSongs(),
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
            SizedBox(height: 16.0),
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
            SizedBox(height: 8.0),
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
            SizedBox(height: 16.0),
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
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        height: 60.0,
        child: Row(
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 30.0,
              height: 60.0,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumDetailScreen(
          title: album.title,
          artist: album.artist,
          assetPath: album.assetPath,
          songs: album.songs, // Pass the list of songs here
        ),
      ),
    );
  }

  Widget _buildAlbumCard(Album album) {
    return GestureDetector(
      onTap: () {
        _addToRecentlyViewed(album.title, album.artist, album.assetPath);
        _handleAlbumTap(album); // Updated navigation method
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
              right: 1.0,
              child: IconButton(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {
                  _showBottomSheet(context, album);
                },
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
                      fontSize: 12.0,
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
                      fontSize: 10.0,
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

final List<Album> albums = [
  Album(
    title: 'This is Lola Amour',
    artist: 'Lola Amour',
    assetPath: 'assets/covers/lolaamour.png',
    songs: [
      Song(
        title: 'Raining In Manila',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/rain.png',
        mp3Path: 'assets/music/raining_in_manila.mp3', // Add MP3 path
      ),
      Song(
        title: 'Fallen',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/fallen.png',
        mp3Path: 'assets/music/fallen.mp3', // Add MP3 path
      ),
      Song(
        title: 'dahan-dahan',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/dahan.png',
        mp3Path: 'assets/music/dahan_dahan.mp3', // Add MP3 path
      ),
      Song(
        title: 'Pwede Ba',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/pwede.png',
        mp3Path: 'assets/music/pwede_ba.mp3', // Add MP3 path
      ),
      Song(
        title: 'Namimiss Ko Na',
        artist: 'Lola Amour',
        assetPath: 'assets/covers/miss.png',
        mp3Path: 'assets/music/namimiss_ko_na.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Adie',
    artist: 'Adie',
    assetPath: 'assets/covers/adie.png',
    songs: [
      Song(
        title: 'Mahika',
        artist: 'Adie',
        assetPath: 'assets/covers/mahika.png',
        mp3Path: 'assets/music/mahika.mp3', // Add MP3 path
      ),
      Song(
        title: 'Tahanan',
        artist: 'Adie',
        assetPath: 'assets/covers/tahan.png',
        mp3Path: 'assets/music/tahanan.mp3', // Add MP3 path
      ),
      Song(
        title: 'Paraluman',
        artist: 'Adie',
        assetPath: 'assets/covers/paraluman.png',
        mp3Path: 'assets/music/paraluman.mp3', // Add MP3 path
      ),
      Song(
        title: 'Oh, Giliw',
        artist: 'Adie',
        assetPath: 'assets/covers/giliw.png',
        mp3Path: 'assets/music/oh_giliw.mp3', // Add MP3 path
      ),
      Song(
        title: 'Kursunada',
        artist: 'Adie',
        assetPath: 'assets/covers/kursunada.png',
        mp3Path: 'assets/music/kursunada.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is The 1975',
    artist: 'The 1975',
    assetPath: 'assets/covers/The 1975.jpeg',
    songs: [
      Song(
        title: 'About You',
        artist: 'The 1975',
        assetPath: 'assets/covers/About you.jpeg',
        mp3Path: 'assets/music/about_you.mp3', // Add MP3 path
      ),
      Song(
        title: 'Somebody Else',
        artist: 'The 1975',
        assetPath: 'assets/covers/Somebody Else.jpeg',
        mp3Path: 'assets/music/somebody_else.mp3', // Add MP3 path
      ),
      Song(
        title: 'Robbers',
        artist: 'The 1975',
        assetPath: 'assets/covers/Robbers.jpeg',
        mp3Path: 'assets/music/robbers.mp3', // Add MP3 path
      ),
      Song(
        title: 'Its Not Living If Its Not With You',
        artist: 'The 1975',
        assetPath: 'assets/covers/ItsNotLivingIfItsNotWithYou.jpeg',
        mp3Path: 'assets/music/its_not_living.mp3', // Add MP3 path
      ),
      Song(
        title: 'Chocolate',
        artist: 'The 1975',
        assetPath: 'assets/covers/Chocolate.jpeg',
        mp3Path: 'assets/music/chocolate.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  Album(
    title: 'This is Taylor Swift',
    artist: 'Taylor Swift',
    assetPath: 'assets/covers/Taylor Swift.jpg',
    songs: [
      Song(
        title: 'Fortnight (feat. Post Malone',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Fortnight feat. Post Malone.jpeg',
        mp3Path: 'assets/music/fortnight_feat_post_malone.mp3', // Add MP3 path
      ),
      Song(
        title: 'Cruel Summer',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Cruel Summer.jpeg',
        mp3Path: 'assets/music/cruel_summer.mp3', // Add MP3 path
      ),
      Song(
        title: 'I Can Do It With a Broken Heart',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/ICanDoItWithaBrokenHeart.jpeg',
        mp3Path:
            'assets/music/i_can_do_it_with_a_broken_heart.mp3', // Add MP3 path
      ),
      Song(
        title: 'Down Bad',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Down Bad.jpeg',
        mp3Path: 'assets/music/down_bad.mp3', // Add MP3 path
      ),
      Song(
        title: 'Guilty as Sin?',
        artist: 'Taylor Swift',
        assetPath: 'assets/covers/Guilty as Sin.jpeg',
        mp3Path: 'assets/music/guilty_as_sin.mp3', // Add MP3 path
      ),
      // Add more songs here
    ],
  ),
  // Add more albums here
];
