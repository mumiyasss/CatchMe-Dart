import 'package:catch_me/ui/signin/SingInViewModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/services.dart';

class SignIn extends StatelessWidget {
  final viewModel = SignInViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.signOut();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Welcome to CatchMe.",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("v0.1 alpha", style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100),),
                  ],
                ),
                Container(
                  height: 45,
                  child: SignInButton(Buttons.Google, onPressed: () {
                    viewModel.googleSignIn();
                  }),
                ),
              ]),
        ),
      ),
    );
  }
}
