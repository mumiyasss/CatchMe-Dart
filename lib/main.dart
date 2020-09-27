import 'package:catch_me/LifecycleEventHandler.dart';
import 'package:catch_me/bloc/background_tasks/online_stamp_bloc.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/store.dart';
import 'package:catch_me/ui/signin/SingInViewModel.dart';
import 'package:catch_me/values/Styles.dart';
import 'package:catch_me/values/language.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/ui/pageview/PageView.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'ui/signin/SignIn.dart';

void main() {
    runApp(MyApp());
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    //     .then((_) async {
    //     String currentLocale = await Devicelocale.currentLocale;
    //     if (currentLocale.startsWith("ru"))
    //         App.lang = RuLang();
    //     else
    //         App.lang = EnLang();
    //     runApp(MyApp());
    // });
}

initIfLoggedIn() async {
    if (SignInViewModel().initUser() != null) {
        App.chatDao = await ChatDao.instance;
        App.personDao = await PersonDao.instance;
    }
}

onAppClose() async {
    ChatStore.instance.then((store) => store.updateDbRightNow());
    PersonStore.instance.then((store) => store.updateDbRightNow());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            // Initialize FlutterFire
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                    return Container(
                        color: Colors.red,
                    );
                }
                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                    return App();
                }
                // Otherwise, show something whilst waiting for initialization to complete
                return Center(
                    child: CircularProgressIndicator(),
                );
            },
        );
    }
}

class App extends StatelessWidget {
    static Language lang = EnLang();
    static String _userUid;

    static String get userUid {
        assert(_userUid != null);
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
        WidgetsBinding.instance.addObserver(LifecycleEventHandler(
            inactiveCallBack: onAppClose(),
            pausedCallBack: onAppClose(),
            suspendingCallBack: onAppClose(),
            resumeCallBack: sendStamp()));

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
        var stream = Observable(FirebaseAuth.instance.authStateChanges())
            .asyncMap((user) async {
            await initIfLoggedIn();
            return user;
        });
        return StreamBuilder<User>(
            stream: stream,
            builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                    return SplashScreen();
                else if (snapshot.hasData) {
                    return MainPage();
                } else {
                    if (snapshot.hasError) {
                        Fluttertoast.showToast(msg: "Ошибка авторизации. ${snapshot.error.toString()}");
                    }
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
