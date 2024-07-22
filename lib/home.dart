import 'package:flutter/material.dart';
import 'widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  final String email;

  const MyHomePage({super.key, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await AuthServices().signOut(context: context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyChooseAccPage()));
                const ScaffoldMessenger(child: Text('Successfully Logged Out'));
              },
            ),
          ],
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Welcome to Home Page',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Color(0xFFFFE382),
          elevation: 0.0,
        ),
        backgroundColor: Color(0xffFFFED3),
        body: Stack(children: [
          // Background image
          Container(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
