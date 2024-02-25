import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Screens/api/apis.dart';
import 'package:we_chat/Screens/helpers/dialogs.dart';
import 'package:we_chat/Screens/home_screen.dart';
import 'package:we_chat/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  _handlegooglebtnclick() {
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nuser:${user.user}');
        log('\nuseradditionalinfo :${user.additionalUserInfo} ');
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          APIs.CreateUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle:$e');
      Dialogs.showSnackbar(context, 'Something Went Wrong!! (Check Internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Welcome To We Chat'),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              right: _isAnimated ? mq.width * .25 : -mq.width * .5,
              child: Image.asset("images/AppIcon.png"),
              top: mq.height * .15,
              width: mq.width * .5,
            ),
            Positioned(
              left: mq.width * .05,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handlegooglebtnclick();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/google.png",
                      height: mq.height * .06,
                    ),
                  ),
                  label: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 19),
                          children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ]))),
              width: mq.width * .9,
              bottom: mq.height * .15,
              height: mq.height * .1,
            )
          ],
        ),
      ),
    );
  }
}
