import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async { /// ANONİM giriş
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }


  Future<User?> createUserWithEmailAndPassword(String email,String password)async{ /// Yeni KULLANICI OLUŞTURMA
    UserCredential userCredential;

    try{
      userCredential= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      print(e.code);
      print(e.message);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email,String password)async{ /// E-posta ve şifre ile GİRİŞ
    final userCredentials= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user;
  }

  Future<void> sendPasswordResetEmail(String email) async { /// E-mail DOĞRULAMA LİNKİ
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signInWithGoogle() async { /// GOOGLE ile giriş
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser!=null){
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    }
    else{return null;}

  }


  Future<void> signOut() async { /// Google HESAPTAN ÇIKIŞ
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Stream<User?> get authStatusStream => _firebaseAuth.authStateChanges();
}
