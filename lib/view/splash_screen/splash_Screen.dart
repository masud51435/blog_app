import 'package:blog_app/view/splash_screen/splash_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topStart,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/nature.png',
            fit: BoxFit.cover,
          ),
          const Positioned(
            left: 20,
            top: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Everyday New',
                  style: TextStyle(
                    fontSize: 27,
                    color: Color.fromARGB(255, 116, 195, 74),
                  ),
                ),
                Text(
                  'Travel Blog',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 116, 195, 74),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
