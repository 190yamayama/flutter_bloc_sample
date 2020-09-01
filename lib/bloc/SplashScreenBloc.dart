import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignInScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:rxdart/rxdart.dart';

class SplashScreenBloc {

  // ignore: close_sinks
  final _authentication = BehaviorSubject<Authentication>();
  final _repository = AuthenticationRepository();

  SplashScreenBloc(BuildContext context) {

    // 認証状態判定
    _authentication.listen((value) {
      Timer(Duration(seconds: 2), () {
        // （backで戻れないように）置き換えて遷移する
        switch (value.authStatus) {
          case AuthStatus.notSignedIn:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => SignInScreen())
            );
            break;
          case AuthStatus.signedUp:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
            );
            break;
          case AuthStatus.signedIn:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
            );
            break;
          case AuthStatus.failed:
          // TODO: ここでエラーになった時の処理を決めて書く。ポップアップメッセージ出してリトライするか？
            break;
          case AuthStatus.initState:
            break;
        }
      });
    });

  }

  // 認証状態確認
  void checkAuthenticationStatus() {
    _repository.checkAuthenticationStatus()
        .then((value) {
          _authentication.add(value);
        });
  }

  void dispose() {
    _authentication.close();
  }

}
