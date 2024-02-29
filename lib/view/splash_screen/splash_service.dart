import 'dart:async';

import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/view/HomePage/HomeScreen.dart';
import 'package:blog_app/view/login/loginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SessionController().userId = user.uid.toString();
      SessionController().img = user.photoURL.toString();
      SessionController().name = user.displayName.toString();
      Timer(
          const Duration(
            seconds: 2,
          ),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage())));
    } else {
      Timer(
          const Duration(
            seconds: 2,
          ),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
