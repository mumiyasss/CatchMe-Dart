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
      body: Center(
        child: Container(
          child: SignInButton(Buttons.Google, onPressed: () {
            viewModel.googleSignIn();
          }),
        ),
      ),
    );
  }
}
