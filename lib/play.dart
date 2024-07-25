// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'widget.dart';

// class MyPlayer extends StatefulWidget {
//   final List<Song> songList; // List of songs
//   final int initialIndex; // Index of the current song

//   MyPlayer({
//     required this.songList,
//     required this.initialIndex,
//   });

//   @override
//   _MyPlayerState createState() => _MyPlayerState();
// }

// class _MyPlayerState extends State<MyPlayer> {
//   late int _currentIndex;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   void _playPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   void _next() {
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % widget.songList.length;
//     });
//   }

//   void _previous() {
//     setState(() {
//       _currentIndex =
//           (_currentIndex - 1 + widget.songList.length) % widget.songList.length;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentSong = widget.songList[_currentIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Now Playing'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset(
//                     currentSong.assetPath,
//                     width: 100.0,
//                     height: 100.0,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     currentSong.title,
//                     style:
//                         TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     currentSong.artist,
//                     style: TextStyle(fontSize: 18.0, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               IconButton(
//                 icon: FaIcon(FontAwesomeIcons.backward),
//                 onPressed: _previous,
//               ),
//               IconButton(
//                 icon: FaIcon(_isPlaying
//                     ? FontAwesomeIcons.pause
//                     : FontAwesomeIcons.play),
//                 onPressed: _playPause,
//               ),
//               IconButton(
//                 icon: FaIcon(FontAwesomeIcons.forward),
//                 onPressed: _next,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
