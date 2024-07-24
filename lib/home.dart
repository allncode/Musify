import 'package:flutter/material.dart';
import 'widget.dart';
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: widget.profileImageUrl != null
                    ? NetworkImage(widget.profileImageUrl!)
                    : null,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'Musify',
          style: GoogleFonts.poppins(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff694F8E),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF222831),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: widget.username != null
                    ? Text(widget.username!, style: GoogleFonts.poppins())
                    : null,
                accountEmail: Text(widget.email, style: GoogleFonts.poppins()),
                currentAccountPicture: widget.profileImageUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileImageUrl!),
                      )
                    : null,
                decoration: BoxDecoration(
                  color: Color(0xFF222831),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home',
                    style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Settings",
                    style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Logout',
                    style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () async {
                  await AuthServices().signOut(context: context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyChooseAccPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Successfully Logged Out',
                            style: GoogleFonts.poppins())),
                  );
                },
              ),
            ],
          ),
        ),
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
            child: Center(child: MySpotify()),
          ),
        ],
      ),
    );
  }
}
