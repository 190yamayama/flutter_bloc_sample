import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/SplashScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc {

  final _authentication = BehaviorSubject<Authentication>();
  final displayName = BehaviorSubject<String>();

  AuthenticationRepository _repository = AuthenticationRepository();

  HomeScreenBloc(BuildContext context, [AuthenticationRepository repository]) {
    _repository = repository ?? AuthenticationRepository();
    _authentication.listen((value) {
      String name = value.firebaseUser?.displayName ?? "";
      displayName.add("$name さん　ホームですよ〜");
      if (value.authStatus == AuthStatus.notSignedIn) {
        _moveSplashScreen(context);
      }
    });

    // 認証状態確認
    _repository.checkAuthenticationStatus()
        .then((value) {
          _authentication.add(value);
        });
  }

  void signOut(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    _repository.signOut()
        .then((value) {
          progress.hide();
          _authentication.add(value);
        });
  }

  void _moveSplashScreen(BuildContext context) {
    // 先に戻っておかないとなぜかpushReplacementがpushの動きをする
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SplashScreen())
    );
  }

  void dispose() {
    _authentication.close();
    displayName.close();
  }

}