import 'package:flutter/material.dart';

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key});

  @override
  State<MySignInPage> createState() => _MySignInUpPageState();
}

class _MySignInUpPageState extends State<MySignInPage> {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
