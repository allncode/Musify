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
            style: GoogleFonts.poppins(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF222831),
          elevation: 0.0,
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF222831), Colors.black],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
