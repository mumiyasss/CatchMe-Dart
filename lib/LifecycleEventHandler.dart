import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
    LifecycleEventHandler({
        this.resumeCallBack,
        this.suspendingCallBack,
        this.pausedCallBack,
        this.inactiveCallBack});

    final Future<void> resumeCallBack;
    final Future<void> suspendingCallBack;
    final Future<void> inactiveCallBack;
    final Future<void> pausedCallBack;

//      @override
//      Future<bool> didPopRoute()
//
//      @override
//      void didHaveMemoryPressure()

    @override
    Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
        switch (state) {
            case AppLifecycleState.inactive:
                await inactiveCallBack;
                break;
            case AppLifecycleState.paused:
                await pausedCallBack;
                break;
            case AppLifecycleState.suspending:
                await suspendingCallBack;
                break;
            case AppLifecycleState.resumed:
                await resumeCallBack;
                break;
        }
        debugPrint('''
=============================================================
               $state
=============================================================
''');
    }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}