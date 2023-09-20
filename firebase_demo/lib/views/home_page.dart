import 'package:firebase_demo/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: ()async{
              Provider.of<Auth>(context,listen: false).signOut();
              print("logout tıklandı");
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Container(child: Text("HOME PAGE"),)),
    );
  }
}
