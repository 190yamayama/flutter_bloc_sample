import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/bloc/HomeScreenBloc.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget with RouteAware {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenBloc>(
      create: (context) => HomeScreenBloc(context),
      dispose: (context, bloc) => bloc.dispose(),
      child: HomeScreenPage(),
    );
  }

}

class HomeScreenPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeScreenBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: bloc.displayName,
          builder: (context, snapshot) {
            return Text(
                (snapshot.data ?? ""),
                textAlign: TextAlign.center
            );
          },
        )
      ),
      drawer: drawerMenu(context),
    );
  }

  Widget drawerMenu(BuildContext context) {
    final bloc = Provider.of<HomeScreenBloc>(context);
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("メニュー"),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
          ListTile(
            title: Text("サインアウト"),
            onTap: () {
              bloc.signOut(context);
            },
          )
        ],
      ),
    );
  }
}
