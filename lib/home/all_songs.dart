import 'package:flutter/material.dart';
import '../widget.dart';

class AllSongsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('adie all songs'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('List of All Songs'),
      ),
    );
  }
}
