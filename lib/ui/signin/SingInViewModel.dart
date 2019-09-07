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
        var user = await initUser();
        var userToCheck = (await Firestore.instance
            .document('users/' + CatchMeApp.userUid)
            .get());
        var userDoesNotExists = userToCheck.data == null;
        if (userDoesNotExists) {
            Firestore.instance.document('users/' + CatchMeApp.userUid).setData({
                'id': CatchMeApp.userUid,
                'name': user.displayName,
                'email': user.email,
                'phone': user.phoneNumber,
                'photo': user.photoUrl
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

    Future<FirebaseUser> initUser() async {
        var firebaseUser = await FirebaseAuth.instance.currentUser();
        if (firebaseUser != null)
            CatchMeApp.userUid = firebaseUser.uid;
        return firebaseUser;
    }

    void signOut() {
        _gSignIn.signOut();
    }
}
