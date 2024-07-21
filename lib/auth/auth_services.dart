// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/widget.dart';

// class AuthServices {
//   Future<void> signup({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       await Future.delayed(const Duration(seconds: 1));
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => MyHomePage(
//                     email: email,
//                     password: password,
//                   )));
//       // } on FirebaseAuthException catch (e) {
//       //   String message = '';
//       //   if (e.code == 'email-already-in-use') {
//       //     print('The account already exists for that email.');
//       //   }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<void> signIn({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);

//       await Future.delayed(const Duration(seconds: 1));
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (BuildContext context) => MyHomePage(
//                     email: email,
//                     password: password,
//                   )));
//       // } on FirebaseAuthException catch (e) {
//       //   String message = '';
//       //   if (e.code == 'user-not-found') {
//       //     print('No user found for that email.');
//       //   } else if (e.code == 'wrong-password') {
//       //     print('Wrong password provided for that user.');
//       //   }
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(
//       //       content: Text(message),
//       //     ),
//       //   );
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<void> signOut({required BuildContext context}) async {
//     await FirebaseAuth.instance.signOut();
//     await Future.delayed(const Duration(seconds: 1));
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => MyChooseAccPage()));
//   }


// }
