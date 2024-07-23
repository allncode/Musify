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
                    onFavoriteTap: () {
                      // Handle the heart icon tap
                      // Implement favorite functionality here
                    },
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
                height: 150.0,
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
                          Navigator.push(
                            context,
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
            builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(album.title),
                backgroundColor: Colors.black,
              ),
              body: AlbumDetailScreen(
                title: album.title,
                artist: album.artist,
                assetPath: album.assetPath,
                songs: album.songs,
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                album.assetPath,
                height: 120.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              album.title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              album.artist,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String assetPath;

  Song({
    required this.title,
    required this.artist,
    required this.assetPath,
  });
}

class Album {
  final String title;
  final String artist;
  final String assetPath;
  final List<Song> songs;

  Album({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.songs,
  });
}

class AlbumDetailScreen extends StatelessWidget {
  final String title;
  final String artist;
  final String assetPath;
  final List<Song> songs; // Pass the list of songs

  const AlbumDetailScreen({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.songs, // Accept the list of songs
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            assetPath,
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
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  artist,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.0,
                  ),
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
                  itemCount: songs.length, // Use the length of the songs list
                  itemBuilder: (context, index) {
                    final song = songs[index];
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Album> albums = [
  Album(
    title: 'Pantropiko',
    artist: 'BINI',
    assetPath: 'assets/covers/pantropiko.jpg',
    songs: [
      Song(
          title: 'Song 1',
          artist: 'Artist 1',
          assetPath: 'assets/images/logo2.png'),
      Song(
          title: 'Song 2',
          artist: 'Artist 2',
          assetPath: 'assets/images/logo2.png'),
      // Add more songs here
    ],
  ),
  Album(
    title: 'Another Album',
    artist: 'Artist Name',
    assetPath: 'assets/covers/pantropiko.jpg',
    songs: [
      Song(
          title: 'Song A',
          artist: 'Artist A',
          assetPath: 'assets/images/logo2.png'),
      Song(
          title: 'Song B',
          artist: 'Artist B',
          assetPath: 'assets/images/logo2.png'),
      // Add more songs here
    ],
  ),
  // Add more albums here
];
