import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/view/HomePage/HomeScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../utlis/toastMsg/toastMessage.dart';

class LoginModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _toggle = true;
  bool _loading = false;

  bool get loading => _loading;
  bool get toggle => _toggle;

  setToggle() {
    _toggle = !_toggle;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    setLoading(true);
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        setLoading(false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        if (context.mounted) {
          Utils.toastMessage('Login successfully', Colors.blue,
              const Icon(Icons.check), context);
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (context.mounted) {
          Utils.toastMessage(
              error.toString(), Colors.red, const Icon(Icons.error), context);
        }
      });
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          Utils.toastMessage('No user found for that email.', Colors.red,
              const Icon(Icons.error), context);
        }
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        if (context.mounted) {
          Utils.toastMessage('Wrong password provided for that user.',
              Colors.red, const Icon(Icons.error), context);
        }
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Utils.toastMessage(
            e.toString(), Colors.red, const Icon(Icons.error), context);
      }
    }
  }

  Future<UserCredential> googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
