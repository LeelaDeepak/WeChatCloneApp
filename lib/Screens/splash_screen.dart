import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/Screens/api/apis.dart';
import 'package:we_chat/Screens/home_screen.dart';
import 'package:we_chat/main.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      if (APIs.auth.currentUser != null) {
        // log('\nUser: ${APIs.me}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              right: mq.width * .25,
              top: mq.height * .35,
              width: mq.width * .5,
              child: Image.asset("images/AppIcon.png"),
            ),
            Positioned(
              width: mq.width,
              bottom: mq.height * .15,
              child: const Text(
                "MADE by SUDAS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
