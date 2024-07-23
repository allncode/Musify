import 'package:flutter/material.dart';
import '../widget.dart';

class YourLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Library'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('List of Songs in Your Library'),
      ),
    );
  }
}
