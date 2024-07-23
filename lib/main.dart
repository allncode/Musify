import 'package:flutter/material.dart';
import 'package:myapp/splash_screen.dart';
import 'package:myapp/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  int _currentIndex = 0; // Track the current page index

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
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
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Music',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                _buildSongCard(context, 'Liked Songs', Icons.favorite,
                    Colors.purple, LikedSongs()),
                _buildSongCard(
                    context, 'FAV', Icons.star, Colors.orange, FavScreen()),
                _buildSongCard(context, 'All Songs', Icons.album, Colors.brown,
                    AllSongsScreen()),
                _buildSongCard(context, 'Arthur Nery', Icons.person,
                    Colors.amber, SongScreen()),
              ],
            ),
          ),
          Text(
            'Popular albums',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Container(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildAlbumCard(
                    'Pantropiko', 'BINI', 'assets/images/logo2.png'),
                _buildAlbumCard('Dilaw', 'Maki', 'assets/images/logo2.png'),
                _buildAlbumCard(
                    'Pleasure', 'Carpenters', 'assets/images/logo2.png'),
                _buildAlbumCard(
                    'Album 4', 'Artist 4', 'assets/images/logo2.png'),
                _buildAlbumCard(
                    'Album 5', 'Artist 5', 'assets/images/logo2.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongCard(BuildContext context, String title, IconData icon,
      Color iconColor, Widget screen) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.all(8.0), // Added margin around the card
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30.0), // Adjusted icon size
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 16.0), // Adjusted text size
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
      ),
    );
  }

  Widget _buildAlbumCard(String title, String artist, String assetPath) {
    return Container(
      width: 150.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              assetPath,
              height: 120.0,
              width: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            artist,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
