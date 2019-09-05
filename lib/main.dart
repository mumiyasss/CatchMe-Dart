import 'package:catch_me/LifecycleEventHandler.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/cached_db.dart';
import 'package:catch_me/dao/cached_db/db/Db.dart';
import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/ui/chatlist/chat_list.dart';
import 'package:catch_me/ui/settings/Settings.dart';
import 'package:catch_me/ui/signin/SingInViewModel.dart';
import 'package:catch_me/values/Strings.dart';
import 'package:catch_me/values/Styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/ui/pageview/PageView.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'ui/signin/SignIn.dart';

void main() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) async {
        await onAppStart();
        runApp(CatchMeApp());
    });
}

onAppStart() async {
    await SignInViewModel().initUser();
    CatchMeApp.chatDao = await ChatDao.instance;
    CatchMeApp.personDao = await PersonDao.instance;
}

onAppClose() async {
    ChatStore.instance.then((store) => store.updateDbRightNow());
    PersonStore.instance.then((store) => store.updateDbRightNow());
}

class CatchMeApp extends StatelessWidget {
    static String _userUid;

    static String get userUid {
        assert(_userUid != null );
        return _userUid;
    }

    static set userUid(String userUid) {
        assert(userUid != null);
        _userUid = userUid;
    }

    static BuildContext appContext;

    static PersonDao personDao;
    static ChatDao chatDao;

    @override
    Widget build(BuildContext context) {
        print(SystemUiOverlayStyle.dark.statusBarColor);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            inactiveCallBack: onAppClose(),
            pausedCallBack: onAppClose(),
            suspendingCallBack: onAppClose()
        ));

        appContext = context;

        return MaterialApp(
            title: Strings.appTitle,
            theme: Styles.mainTheme,
            home: _handleCurrentScreen(),
            debugShowCheckedModeBanner: false,
        );
    }

    Widget _handleCurrentScreen() {
        var stream = Observable(FirebaseAuth.instance.onAuthStateChanged)
            .asyncMap((user) async {
            await SignInViewModel().initUser();
            return user;
        });
        return StreamBuilder<FirebaseUser>(
            stream: stream,
            builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                    return SplashScreen();
                else if (snapshot.hasData) {
                    //SignInViewModel().initUser();
                    return MainPage();
                } else {
                    print(snapshot.toString());
                    return SignIn();
                }
            });
    }
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

