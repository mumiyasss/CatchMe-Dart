import 'package:catch_me/ui/signin/SingInViewModel.dart';
import 'package:catch_me/values/Strings.dart';
import 'package:catch_me/values/Styles.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/ui/pageview/PageView.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui/signin/SignIn.dart';

void main() {
	SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
			.then((_) {
		runApp(CatchMeApp());
	});
}

class CatchMeApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
			statusBarColor: Colors.white,
		));
		return MaterialApp(
			title: Strings.appTitle,
			theme: Styles.mainTheme,
			home: _handleCurrentScreen(),
		);
	}

	Widget _handleCurrentScreen() {
		return StreamBuilder<FirebaseUser>(
				stream: FirebaseAuth.instance.onAuthStateChanged,
				builder: (BuildContext context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting)
						return SplashScreen();
					else if (snapshot.hasData) {
						SignInViewModel().initUserId();
						return MainPage();
					} else
						return SignIn();
				});
	}

	static String userUid;
}

class SplashScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Text("LOADING..."),
			),
		);
	}
}
