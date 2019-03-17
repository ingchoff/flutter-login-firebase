import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
    @required this.user
  }) : super(key : key);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
     final first = new Center(
      child: new Text(user.uid, textAlign: TextAlign.center, style: new TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold)),
    );

    final second = new Center(
      child: new Text('Notify', textAlign: TextAlign.center , style: new TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold)),
    );

    final third = new Center(
      child: new Text('Map', textAlign: TextAlign.center, style: new TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold)),
    );

    final fouth = new Center(
      child: new Text('Profile', textAlign: TextAlign.center, style: new TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold)),
    );
    
    final fifth = new Center(
      child: new Text('Setup', textAlign: TextAlign.center, style: new TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold)),
    );

    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          bottomNavigationBar: new Material(
            color: Colors.blue,
            child: new TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.dashboard)),
                Tab(icon: Icon(Icons.notifications)),
                Tab(icon: Icon(Icons.explore)),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.settings))
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Home'),
            centerTitle: true,
          ),
          body: TabBarView(
            children: <Widget>[
              first, second, third, fouth, fifth
            ],
          ),
          ),
        ),
      );
    }
}