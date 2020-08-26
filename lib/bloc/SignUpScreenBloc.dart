import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreenBloc {

  // ignore: close_sinks
  final _authentication = BehaviorSubject<Authentication>();
  // ignore: close_sinks
  final email = BehaviorSubject<String>();
  // ignore: close_sinks
  final displayName = BehaviorSubject<String>();
  // ignore: close_sinks
  final password = BehaviorSubject<String>();
  // ignore: close_sinks
  final errorMessage = BehaviorSubject<String>();

  final _repository = AuthenticationRepository();

  SignUpScreenBloc(BuildContext context) {
    _authentication.listen((value) {
      errorMessage.add(value.errorMessage);
      if (value.authStatus == AuthStatus.signedIn) {
        _moveHomeScreen(context);
      }
    });
  }


  bool isEmpty() {
    if (displayName.value.isEmpty || email.value.isEmpty || password.value.isEmpty) {
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    _repository.signUp(displayName.value, email.value, password.value)
        .then((value) {
          progress.hide();
          _authentication.add(value);
        });
  }

  void moveSignInScreen(BuildContext context) {
    Navigator.pop(context);
  }

  void _moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

  void dispose() {
    _authentication.close();
    displayName.close();
    email.close();
    password.close();
    errorMessage.close();
  }
}