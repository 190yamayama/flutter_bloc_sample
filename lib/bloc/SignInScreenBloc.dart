import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/repository/AuthenticationRepository.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignInScreen.dart';
import 'package:flutter_firebase_app/widget/screen/SignUpScreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rxdart/rxdart.dart';

class SignInScreenBloc {

  final _authentication = BehaviorSubject<Authentication>();
  final email = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  final errorMessage = BehaviorSubject<String>();

  AuthenticationRepository _repository = AuthenticationRepository();

  SignInScreenBloc(BuildContext context, [AuthenticationRepository repository]) {
    _repository = repository ?? AuthenticationRepository();
    _authentication.listen((value) {
      errorMessage.add(value.errorMessage);
      if (value.authStatus == AuthStatus.signedIn) {
        _moveHomeScreen(context);
      }
    });
  }

  bool validateAndSave() {
    final form = SignInScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool isEmpty() {
    if (email.value.isEmpty || password.value.isEmpty) {
      return true;
    }
    return false;
  }

  void signIn(BuildContext context) {
    final ProgressDialog progress = new ProgressDialog(context);
    progress.show();
    _repository.signIn(email.value, password.value)
        .then((value) {
          progress.hide();
          _authentication.add(value);
        });
  }

  void _moveHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
    );
  }

  void moveSignUpScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())
    );
  }

  void dispose() {
    _authentication.close();
    email.close();
    password.close();
    errorMessage.close();
  }

}