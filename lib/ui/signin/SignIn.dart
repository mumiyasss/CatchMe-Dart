import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/services.dart';

class SignIn extends StatelessWidget {
  final _gSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    _gSignIn.signOut();
    return Scaffold(
      body: Center(
        child: Container(
          child: SignInButton(Buttons.Google, onPressed: () {
           
            _googleSignIn();
            
          }),
        ),
      ),
    );
  }

  void _googleSignIn() async {
    try { // Todo: error handling
      GoogleSignInAccount googleSignInAccount =
          await _gSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication authentication =
            await googleSignInAccount.authentication;
        await FirebaseAuth.instance.signInWithGoogle(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);
      }
    } on PlatformException {}
  }
}
