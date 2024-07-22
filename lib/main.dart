import 'package:flutter/material.dart';
import 'package:myapp/splash_screen.dart';
import 'package:myapp/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffB692C2)),
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
    );
  }
}

class MySpotify extends StatefulWidget {
  const MySpotify({super.key});

  @override
  State<MySpotify> createState() => _MySpotifyState();
}

class _MySpotifyState extends State<MySpotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
