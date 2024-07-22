import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key});

  @override
  State<MySignInPage> createState() => _MySignInPageState();
}

class _MySignInPageState extends State<MySignInPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      // Sign out from any currently signed-in account
      await _googleSignIn.signOut();

      // Sign in with Google and prompt user to choose an account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the Google credentials
        await _auth.signInWithCredential(credential);

        // Navigate to the next page
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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 150,
                    height: 150,
                  ),
                  Text("Musify",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    prefixIcon: Icon(Icons.email,
                                        color: Color(0xff694F8E)),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    labelText: 'Password',
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    prefixIcon: Icon(Icons.lock,
                                        color: Color(0xff694F8E)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color(0xff694F8E)),
                                      onPressed: _toggleShowPassword,
                                    ),
                                  ),
                                  obscureText: !_showPassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await AuthServices().signIn(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                }
                              },
                              child: Text(
                                'Log in',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xff694F8E);
                                    }
                                    return const Color(0xffB692C2);
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Sign in with: ",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SignInButton(
                                Buttons.facebook,
                                mini: true,
                                onPressed: () {
                                  // Handle Facebook login
                                },
                              ),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: _signInWithGoogle,
                                  child: Image.asset('assets/images/search.png',
                                      height: 30, width: 30),
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Color(0xff686D76)),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                    elevation:
                                        WidgetStateProperty.all<double>(2.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 12),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage())),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showConPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleShowConPassword() {
    setState(() {
      _showConPassword = !_showConPassword;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      // Sign out from any currently signed-in account
      await _googleSignIn.signOut();

      // Sign in with Google and prompt user to choose an account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the Google credentials
        await _auth.signInWithCredential(credential);

        // Navigate to the next page
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
            child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(children: [
                        SizedBox(height: 100),
                        Image.asset(
                          'assets/images/logo2.png',
                          width: 150,
                          height: 150,
                        ),
                        Text("Musify",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: _emailController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 10.0),
                                                labelText: 'Email',
                                                labelStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                prefixIcon: Icon(Icons.email,
                                                    color: Color(0xff694F8E)),
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                } else if (!RegExp(
                                                        r'^[^@]+@[^@]+\.[^@]+$')
                                                    .hasMatch(value)) {
                                                  return 'Please enter a valid email address';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: _passwordController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 10.0),
                                                labelText: 'Password',
                                                labelStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                prefixIcon: Icon(Icons.lock,
                                                    color: Color(0xff694F8E)),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      _showPassword
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Color(0xff694F8E)),
                                                  onPressed:
                                                      _toggleShowPassword,
                                                ),
                                              ),
                                              obscureText: !_showPassword,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                } else if (!RegExp(
                                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                                    .hasMatch(value)) {
                                                  return 'Password must be at least one A,a,1,@ and 8 characters in length';
                                                } else if (value !=
                                                    _passwordController.text) {
                                                  return 'Passwords do not match';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller:
                                                  _confirmPasswordController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 10.0),
                                                labelText: 'Confirm Password',
                                                labelStyle: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                prefixIcon: Icon(Icons.lock,
                                                    color: Color(0xff694F8E)),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      _showConPassword
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Color(0xff694F8E)),
                                                  onPressed:
                                                      _toggleShowConPassword,
                                                ),
                                              ),
                                              obscureText: !_showConPassword,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                } else if (!RegExp(
                                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                                    .hasMatch(value)) {
                                                  return 'Password must be at least one A,a,1,@ and 8 characters in length';
                                                } else if (value !=
                                                    _passwordController.text) {
                                                  return 'Passwords do not match';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    try {
                                                      await AuthServices()
                                                          .signup(
                                                        context: context,
                                                        email: _emailController
                                                            .text,
                                                        password:
                                                            _passwordController
                                                                .text,
                                                      );
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Sign up',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return const Color(
                                                            0xff694F8E);
                                                      }
                                                      return const Color(
                                                          0xffB692C2);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Sign up with: ",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SignInButton(
                                                  Buttons.facebook,
                                                  mini: true,
                                                  onPressed: () {
                                                    // Handle Facebook login
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                  height: 35,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                        _signInWithGoogle,
                                                    child: Image.asset(
                                                        'assets/images/search.png',
                                                        height: 30,
                                                        width: 30),
                                                    style: ButtonStyle(
                                                      shape: WidgetStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all<Color>(Color(
                                                                  0xff686D76)),
                                                      padding:
                                                          WidgetStateProperty
                                                              .all<EdgeInsets>(
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0),
                                                      ),
                                                      elevation:
                                                          WidgetStateProperty
                                                              .all<double>(2.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Already have an account? ",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MySignInPage())),
                                                  child: Text(
                                                    'Sign in',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                )))
                      ]),
                    )))));
  }
}
