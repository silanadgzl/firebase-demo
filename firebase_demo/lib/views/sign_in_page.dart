import 'package:firebase_demo/services/auth.dart';
import 'package:firebase_demo/views/email_sign_in.dart';
import 'package:firebase_demo/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {

    setState(() {
      _isLoading = true;
    });

    final user = await Provider.of<Auth>(context, listen: false).signInAnonymously();

    setState(() {
      _isLoading = false;
    });

    print(user?.uid);
  }

  void _onSignInAnonymouslyPressed() {
    if (!_isLoading) {
      _signInAnonymously();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<Auth>(context, listen: false).signOut();
              print("logout tıklandı");
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign In Page", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 30),
            MyElevatedButton(
              color: Colors.blue,
              child: const Text("Sign In Anonymously"),
              onPressed: _onSignInAnonymouslyPressed,
            ),
            const SizedBox(height: 10),
            MyElevatedButton(
              color: Colors.orange,
              child: const Text("Sign In Email/Password"),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => const EmailSignInPage()));
                },
            ),
            const SizedBox(height: 10),
            MyElevatedButton(
              color: Colors.orange,
              child: const Text("Google Sign In"),
              onPressed: ()async {
                final user = await Provider.of<Auth>(context,listen: false).signInWithGoogle();
                print(user);
              },
            ),
          ],
        ),
      ),
    );
  }
}