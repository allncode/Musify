// import 'package:flutter/material.dart';

// class AlbumDetailScreen extends StatelessWidget {
//   final String title;
//   final String artist;
//   final String assetPath;
//   // final List<Song> songs; // Pass the list of songs

//   const AlbumDetailScreen({
//     required this.title,
//     required this.artist,
//     required this.assetPath,
//     required this.songs, // Accept the list of songs
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.asset(
//               assetPath,
//               width: double.infinity,
//               height: 300.0,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     artist,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Songs',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: songs.length, // Use the length of the songs list
//                     itemBuilder: (context, index) {
//                       final song = songs[index];
//                       return ListTile(
//                         leading: Icon(Icons.music_note, color: Colors.white),
//                         title: Text(
//                           song.title,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         subtitle: Text(
//                           song.artist,
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         onTap: () {
//                           // Handle song tap if needed
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }
