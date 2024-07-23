import 'package:flutter/material.dart';
import '../widget.dart';

class SongScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arthur Nery'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('List of Arthur Nery\'s Songs'),
      ),
    );
  }
}
