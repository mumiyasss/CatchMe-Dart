import 'package:catch_me/LifecycleEventHandler.dart';
import 'package:catch_me/bloc/background_tasks/online_stamp_bloc.dart';
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
import 'package:catch_me/values/Styles.dart';
import 'package:catch_me/values/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devicelocale/devicelocale.dart';
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
        List languages = await Devicelocale.preferredLanguages;
        if ((languages[0] as String).startsWith("ru"))
            App.lang = RuLang();
        else App.lang = EnLang();

        await initIfLoggedIn();
        runApp(App());
    });
}

initIfLoggedIn() async {
    if (await SignInViewModel().initUser() != null) {
        App.chatDao = await ChatDao.instance;
        App.personDao = await PersonDao.instance;
    }
}

onAppClose() async {
    ChatStore.instance.then((store) => store.updateDbRightNow());
    PersonStore.instance.then((store) => store.updateDbRightNow());
}

class App extends StatelessWidget {

    static Language lang = EnLang();
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

    final _onlineStampBloc = OnlineStampBloc();
    sendStamp() async {
        _onlineStampBloc.dispatch(SendStamp());
    }

    @override
    Widget build(BuildContext context) {
        // определение языка системы и присвоение нужного lang
        print(SystemUiOverlayStyle.dark.statusBarColor);
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            inactiveCallBack: onAppClose(),
            pausedCallBack: onAppClose(),
            suspendingCallBack: onAppClose(),
            resumeCallBack: sendStamp()
        ));

        appContext = context;

        return MaterialApp(
            title: App.lang.appTitle,
            theme: Styles.mainTheme,
            home: _handleCurrentScreen(),
            debugShowCheckedModeBanner: false,
            supportedLocales: [
                Locale('en'),
                Locale('ru'),
            ],
        );
    }

    Widget _handleCurrentScreen() {
        var stream = Observable(FirebaseAuth.instance.onAuthStateChanged)
            .asyncMap((user) async {
            await initIfLoggedIn();
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

