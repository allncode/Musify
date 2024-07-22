import 'package:flutter/material.dart';
import 'widget.dart'; // Ensure this import is correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  final String email;
  final String? username; // Optional username
  final String? profileImageUrl; // Optional profile image URL

  const MyHomePage({
    super.key,
    required this.email,
    this.username,
    this.profileImageUrl,
  });

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyChooseAccPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully Logged Out')),
              );
            },
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome to Home Page',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF222831),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
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
                  if (widget.profileImageUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.profileImageUrl!),
                      radius: 50,
                    ),
                  if (widget.username != null) SizedBox(height: 16),
                  if (widget.username != null)
                    Text(
                      widget.username!,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 8),
                  Text(
                    widget.email,
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
        ],
      ),
    );
  }
}
