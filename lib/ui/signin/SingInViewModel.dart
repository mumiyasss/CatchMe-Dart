import 'package:catch_me/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel {
  final _gSignIn = GoogleSignIn();

  void googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;
    await FirebaseAuth.instance.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    var user = await FirebaseAuth.instance.currentUser();
    CatchMeApp.userUid = user.uid;
    print(CatchMeApp.userUid);
    // var userToCheck = (await Firestore.instance
    //     .document('users/' + CatchMeApp.userUid)
    //     .get());
    // var userDoesNotExists = userToCheck.data == null;
    // if (userDoesNotExists) {
      Firestore.instance
          .document('users/' + CatchMeApp.userUid)
          .setData({'id': CatchMeApp.userUid, 'name': user.displayName});
    // }
  }

  void signOut() {
    _gSignIn.signOut();
  }
}
