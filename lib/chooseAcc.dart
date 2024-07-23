import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widget.dart';

class MyChooseAccPage extends StatefulWidget {
  const MyChooseAccPage({super.key});

  @override
  State<MyChooseAccPage> createState() => _MyChooseAccPageState();
}

class _MyChooseAccPageState extends State<MyChooseAccPage> {
  TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyHomePage(email: _emailController.text),
          ),
        );
        print('Signed in as ${googleUser.displayName}');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Image.asset(
                'assets/images/logo2.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                "Find your music, \n  here on Musify",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8.0),
                      Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    backgroundColor: Color(0xff694F8E),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: _signInWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/search.png',
                        height: 20.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '  Continue with Google',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(0xff694F8E),
                        width: 2.0,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await _authServices.facebookLogin(context);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/facebook.png',
                        height: 20.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '  Continue with Facebook',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Color(0xff694F8E),
                        width: 2.0,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MySignInPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8.0),
                      Text(
                        'Log in',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    elevation: 2.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
