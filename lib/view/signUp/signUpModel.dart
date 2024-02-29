import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/view/HomePage/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utlis/toastMsg/toastMessage.dart';

class SignUpModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref('Users_profile');

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

  Future<void> signUp(
    String userName,
    String email,
    String password,
    BuildContext context,
  ) async {
    setLoading(true);
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          SessionController().userId = value.user!.uid.toString();
          reference.child(value.user!.uid.toString()).set({
            'uid': value.user!.uid.toString(),
            'name': userName.toString(),
            'email': email.toString(),
            'password': password.toString(),
            'number': '',
            'profilePic': '',
          }).then((value) {
            setLoading(false);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }).onError((error, stackTrace) {
            setLoading(false);
            Utils.toastMessage(
                error.toString(), Colors.red, const Icon(Icons.error), context);
          });
          setLoading(false);
          Utils.toastMessage('SignUp successfully', Colors.blue,
              const Icon(Icons.check), context);
        },
      );
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'weak-password') {
        if (context.mounted) {
          Utils.toastMessage('password shuld be atleast 6 character',
              Colors.red, const Icon(Icons.error), context);
        }

        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          Utils.toastMessage(
              'The account already exists for that email,please login now',
              Colors.red,
              const Icon(Icons.error),
              context);
        }
        if (kDebugMode) {
          print('The account already exists for that email.');
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
}
