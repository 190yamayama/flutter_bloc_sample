import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/bloc/SplashScreenBloc.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {

    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    // Push通知の許可
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    // Push通知の許可・設定(iOS)
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    return Provider<SplashScreenBloc>(
      create: (context) => SplashScreenBloc(context),
      dispose: (context, bloc) => bloc.dispose(),
      child: SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SplashScreenBloc>(context);
    bloc.checkAuthenticationStatus();
    return MaterialApp(
        title: "Flutter Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(child: Image(image: AssetImage('assets/splash.png'))),
        )
    );
  }
}