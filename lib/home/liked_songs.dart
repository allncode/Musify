import 'package:flutter/material.dart';
import '../widget.dart';

class LikedSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Songs'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('List of Liked Songs'),
      ),
    );
  }
}
