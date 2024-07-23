import 'package:flutter/material.dart';
import '../widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Musify Home'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
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
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildSongCard(context, 'Liked Songs', Icons.favorite,
                      Colors.purple, LikedSongs()),
                  _buildSongCard(
                      context, 'FAV', Icons.star, Colors.orange, FavScreen()),
                  _buildSongCard(context, 'adie all songs', Icons.album,
                      Colors.brown, AllSongsScreen()),
                  _buildSongCard(context, 'Arthur Nery', Icons.person,
                      Colors.amber, SongScreen()),
                ],
              ),
              SizedBox(height: 20.0),
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
                    _buildAlbumCard('Pantropiko', 'BINI', 'assets/album1.jpg'),
                    _buildAlbumCard('Dilaw', 'Maki', 'assets/album2.jpg'),
                    _buildAlbumCard(
                        'Pleasure', 'Carpenters', 'assets/album3.jpg'),
                    _buildAlbumCard('Album 4', 'Artist 4', 'assets/album4.jpg'),
                    _buildAlbumCard('Album 5', 'Artist 5', 'assets/album5.jpg'),
                    // Add more album cards as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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
          switch (index) {
            case 0:
              // Navigate to HomeScreen (already on HomeScreen, so no action needed)
              break;
            case 1:
              // Navigate to SearchScreen
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              // Navigate to YourLibraryScreen
              Navigator.pushNamed(context, '/your_library');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSongCard(BuildContext context, String title, IconData icon,
      Color iconColor, Widget screen) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
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
