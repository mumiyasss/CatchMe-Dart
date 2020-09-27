import 'dart:async';

import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel {
    final _gSignIn = GoogleSignIn();

    void googleSignIn() async {
        final googleCredential = await _getGoogleCredential();
        await FirebaseAuth.instance.signInWithCredential(googleCredential);
        var user = initUser();
        var userToCheck = (await FirebaseFirestore.instance
            .doc('users/' + App.userUid)
            .get());
        var userDoesNotExists = userToCheck.data == null;
        if (userDoesNotExists) {
            FirebaseFirestore.instance.doc('users/' + App.userUid).set({
                userIdColumn: App.userUid,
                nameColumn: user.displayName,
                emailColumn: user.email,
                phoneColumn: user.phoneNumber,
                photoUrlColumn: user.photoURL
            });
        }
    }

    Future<AuthCredential> _getGoogleCredential() async {
        GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
        GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

        return GoogleAuthProvider.getCredential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken
        );
    }

    User initUser()  {
        var firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null)
            App.userUid = firebaseUser.uid;
        return firebaseUser;
    }

    void signOut() {
        _gSignIn.signOut();
    }
}
