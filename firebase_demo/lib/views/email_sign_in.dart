import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

enum FormStatus { signIn, register, reset }

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({super.key});

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  //değişken tanımlayıp bu değişkenin değerine göre iki formdan birini widget ağacına bağla
  FormStatus _formStatus = FormStatus.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.register
                ? buildRegisterForm()
                : buildResetForm(),
      ),
    );
  }

  Padding buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Lütfen Giriş Yapınız.", style: TextStyle(fontSize: 25)),
            TextFormField(
              controller: _emailController,
              validator: (val) {
                if (val == null || !EmailValidator.validate(val)) {
                  //EmailValidator paketi ile girilen text geçerli email formatında değilse hata mesajı yazdırır
                  return "Lütfen geçerli bir e-posta adresi giriniz";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value!.length < 6) {
                  return "Şifreniz en az 6 karakterden oluşmalıdır";
                } else {
                  null;
                }
              },
              obscureText: true, //girilen text * şeklinde yazılır görünmez
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: "Şifre",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  if (_signInFormKey.currentState!.validate()) {
                    //validate formun içindeki tüm alanları kontrol eden bir metottur.
                    final user = await Provider.of<Auth>(context, listen: false)
                        .signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text);

                    if (!user!.emailVerified) {
                      await _showMyDialog();
                      await Provider.of<Auth>(context, listen: false).signOut();
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text("Giriş")),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.register;
                  });
                },
                child: const Text("Kayıt Ol")),
            TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.reset;
                  });
                },
                child: const Text("Şifremi unuttum"))
          ],
        ),
      ),
    );
  }

  Padding buildResetForm() {
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Şifre Yenileme", style: TextStyle(fontSize: 25)),
            TextFormField(
              controller: _emailController,
              validator: (val) {
                if (val == null || !EmailValidator.validate(val)) {
                  //EmailValidator paketi ile girilen text geçerli email formatında değilse hata mesajı yazdırır
                  return "Lütfen geçerli bir e-posta adresi giriniz";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(

                ///  E-mail DOĞRULAMA LİNKİ bu buton içinde yazıldı
                onPressed: () async {
                  if (_resetFormKey.currentState!.validate()) {
                    //validate formun içindeki tüm alanları kontrol eden bir metottur.
                    await Provider.of<Auth>(context, listen: false).sendPasswordResetEmail(_emailController.text);
                    await _showResetPasswordDialog();

                    Navigator.pop(context);
                  }
                },
                child: const Text("Gönder")),
          ],
        ),
      ),
    );
  }

  Padding buildRegisterForm() {
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Kayıt Formu", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "Lütfen geçerli bir e posta giriniz!";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.length < 6) {
                    return "Şifreniz en az 6 karakterden oluşmalıdır.";
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Şifre girin",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordConfirmController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Şifreler uyuşmuyor";
                  } else {
                    null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Şifreyi tekrar girin",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_registerFormKey.currentState!.validate()) {
                        //herşey yolundaysa if içine gir
                        //kullanıcı bilgilerini döndür
                        final user =
                            await Provider.of<Auth>(context, listen: false).createUserWithEmailAndPassword(_emailController.text,_passwordController.text);
                        //link yolla
                        if (!user!.emailVerified) {
                          await user?.sendEmailVerification();
                        }
                        await _showMyDialog();

                        await Provider.of<Auth>(context, listen: false).signOut();

                        setState(() {
                          _formStatus = FormStatus.signIn;
                        });
                      }
                    } on FirebaseAuthException catch (e) {
                      print("Kayıt formu içerisinde hata yakalandı");
                    }
                  },
                  child: const Text("Kayıt")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  },
                  child: const Text("Zaten Üye Misiniz?"))
            ],
          )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Lütfen mailinizi kontrol ediniz'),
                Text('Onay linkini tıklayıp tekrar giriş yapmalısınız.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifre Yenileme'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Lütfen mailinizi kontrol ediniz'),
                Text('Linke tıklayarak şifrenizi yenileyiniz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
