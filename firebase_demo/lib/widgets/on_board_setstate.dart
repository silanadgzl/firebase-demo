import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/views/sign_in_page.dart';
import 'package:flutter/material.dart';
import '../views/home_page.dart';

class OnBoardWidget extends StatefulWidget {
  const OnBoardWidget({super.key});

  @override
  State<OnBoardWidget> createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  late bool _isLogged = false; // Başlangıçta false olarak ilklendirin

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user == null) {
        print("User is currently signed out !");
        setState(() {
          _isLogged = false;
        });
      } else {
        print("User is signed in !");
        setState(() {
          _isLogged = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLogged == null
        ? const Center(child: CircularProgressIndicator())
        : _isLogged
        ? const HomePage()
        : const SignInPage();
  }
}
