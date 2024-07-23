import 'package:flutter/material.dart';
import 'package:myapp/splash_screen.dart';
import 'package:myapp/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  List<Map<String, String>> recentlyViewed = [];
  Song? _currentSong;
  List<Song> recentlyPlayed = []; // Add this line

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
                _currentIndex = index;
              });
            },
            children: [
              _buildMusicPage(),
              SearchScreen(),
              YourLibrary(),
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
                      // You could implement navigation to a detailed player screen here
                    },
                    onMoreOptionsTap: () {
                      // Handle the three-dots icon tap
                      // Show more options or a menu here
                    },
                    onFavoriteTap: _handleFavoriteTap,
                  )
                : SizedBox.shrink(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
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
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
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
                _buildSongCard(context, 'Liked Songs', Icons.favorite,
                    Colors.purple, LikedSongs()),
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
              height: 150.0,
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
            SizedBox(height: 16.0),
            if (recentlyPlayed.isNotEmpty) ...[
              Text(
                'Recently Played Songs',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 150.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: recentlyPlayed.reversed.map((song) {
                    return _buildSongCardForListView(song);
                  }).toList(),
                ),
              ),
            ],
            SizedBox(height: 16.0),
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
              SizedBox(height: 30.0),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSongCardForListView(Song song) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSong = song;
          _addToRecentlyPlayed(song); // Add this line
        });
      },
      child: Container(
        width: 120.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                song.assetPath,
                height: 100.0,
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              song.title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildSongCard(BuildContext context, String title, IconData icon,
      Color iconColor, Widget screen) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.all(8.0),
      child: Container(
        width: 150.0,
        height: 150.0,
        child: ListTile(
          leading: Icon(icon, color: iconColor, size: 30.0),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
                settings: RouteSettings(
                  arguments: albums, // Pass the list of albums here
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlbumCard(Album album) {
    return GestureDetector(
      onTap: () {
        _addToRecentlyViewed(album.title, album.artist, album.assetPath);
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
      child: Container(
        width: 150.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                album.assetPath,
                height: 120.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8.0,
              right: 1.0,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  _handleMenuSelection(value, album);
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'Option1',
                    child: Text('Option 1'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option2',
                    child: Text('Option 2'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option3',
                    child: Text('Option 3'),
                  ),
                ],
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    album.artist,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
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
          assetPath: 'assets/covers/rain.png'),
      Song(
          title: 'Fallen',
          artist: 'Lola Amour',
          assetPath: 'assets/covers/fallen.png'),
      Song(
          title: 'dahan-dahan',
          artist: 'Lola Amour',
          assetPath: 'assets/covers/dahan.png'),
      Song(
          title: 'Pwede Ba',
          artist: 'Lola Amour',
          assetPath: 'assets/covers/pwede.png'),
      Song(
          title: 'Namimiss Ko Na',
          artist: 'Lola Amour',
          assetPath: 'assets/covers/miss.png'),
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
          assetPath: 'assets/covers/mahika.png'),
      Song(
          title: 'Tahanan',
          artist: 'Adie',
          assetPath: 'assets/covers/tahan.png'),
      Song(
          title: 'Paraluman',
          artist: 'Adie',
          assetPath: 'assets/covers/paraluman.png'),
      Song(
          title: 'Oh, Giliw',
          artist: 'Adie',
          assetPath: 'assets/covers/giliw.png'),
      Song(
          title: 'Kursunada',
          artist: 'Adie',
          assetPath: 'assets/covers/kursunada.png'),
      // Add more songs here
    ],
  ),
  // Add more albums here
];
