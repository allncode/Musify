import 'package:flutter/material.dart';
import '../widget.dart';

class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAV'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('List of Favorite Songs'),
      ),
    );
  }
}
