import 'package:flutter/material.dart';
import '../widget.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Search songs...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                // Implement search functionality here
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Search Results',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildSearchResultCard(
                      'Song 1', 'Artist 1', 'assets/images/logo2.png'),
                  _buildSearchResultCard(
                      'Song 2', 'Artist 2', 'assets/images/logo2.png'),
                  _buildSearchResultCard(
                      'Song 3', 'Artist 3', 'assets/images/logo2.png'),
                  // Add more search result cards as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(String title, String artist, String assetPath) {
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
        onTap: () {
          // Implement onTap functionality here
        },
      ),
    );
  }
}
