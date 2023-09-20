import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/services/auth.dart';
import 'package:firebase_demo/widgets/on_board_setstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Firebase'in başlatılmasını bekleyin
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Firebase başlatıldıysa, Auth sağlayıcısı ile MyApp'ı sarın
          return Provider<Auth>(
            create: (context) => Auth(),
            child: MaterialApp(
              theme: ThemeData(primarySwatch: Colors.blue),
              home: const OnBoardWidget(),
            ),
          );
        }

        // Firebase başlatılıncaya kadar beklerken bir yükleme göstergesi gösterin
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
