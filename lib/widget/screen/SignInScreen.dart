import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/bloc/SignInScreenBloc.dart';
import 'package:flutter_firebase_app/widget/component/PrimaryButton.dart';
import 'package:provider/provider.dart';


class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    return Provider<SignInScreenBloc>(
      create: (context) => SignInScreenBloc(context),
      dispose: (context, bloc) => bloc.dispose(),
      child: SignInScreenPage(),
    );
  }

}

class SignInScreenPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Screen"),
      ),
      body: new Center(
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget> [
              logoImage(),
              hintText(context),
              const SizedBox(height: 10.0),
              new Center(
                  child: new Form(
                      key: SignInScreen.formKey,
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            emailText(context),
                            passwordText(context),
                            signInButton(context),
                            signUpButton(context),
                          ]
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logoImage() {
    return const SizedBox(
      height: 200.0,
      width: 200.0,
      child: Image(
        image: AssetImage('assets/splash.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget emailText(BuildContext context) {
    final bloc = Provider.of<SignInScreenBloc>(context);
    return padded(child: new TextFormField(
      key: new Key("email"),
      decoration: new InputDecoration(labelText: "Email"),
      autocorrect: false,
      validator: (val) => val.isEmpty ? "emailを入力してください" : null,
      onSaved: (val) => bloc.email.add(val),
    ));
  }

  Widget passwordText(BuildContext context) {
    final bloc = Provider.of<SignInScreenBloc>(context);
    return padded(child: new TextFormField(
      key: new Key("password"),
      decoration: new InputDecoration(labelText: "Password"),
      obscureText: true,
      autocorrect: false,
      validator: (val) => val.isEmpty ? "パスワードを入力してください" : null,
      onSaved: (val) => bloc.password.add(val),
    ));
  }

  Widget signInButton(BuildContext context) {
    final bloc = Provider.of<SignInScreenBloc>(context);
    return new PrimaryButton(
        key: new Key("signIn"),
        text: "サインイン",
        height: 44.0,
        onPressed: () {
          if (!bloc.validateAndSave()) {
            return;
          }
          if (bloc.isEmpty()) {
            return;
          }
          bloc.signIn(context);
        }
    );
  }

  Widget signUpButton(BuildContext context) {
    final bloc = Provider.of<SignInScreenBloc>(context);
    return new FlatButton(
      key: new Key("signUp"),
      textColor: Colors.green,
      child: new Text(
          "初めて利用する方\n（サインアップ）",
          textAlign: TextAlign.center
      ),
      onPressed: () => {
        bloc.moveSignUpScreen(context)
      },
    );
  }

  Widget hintText(BuildContext context) {
    final bloc = Provider.of<SignInScreenBloc>(context);
    return new Container(
      //height: 80.0,
      padding: const EdgeInsets.all(32.0),
      child: StreamBuilder(
        stream: bloc.errorMessage,
        builder: (context, snapshot) {
          return Text(
              (snapshot.data ?? ""),
              key: new Key("hint"),
              style: new TextStyle(fontSize: 18.0, color: Colors.grey),
              textAlign: TextAlign.center
          );
        },
      )
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}