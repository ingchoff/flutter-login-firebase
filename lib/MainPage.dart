import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
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
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/data.txt');
  }

  Future<String> readFile(String key) async {
    try {
      final file = await _localFile;
      // Read the file
      Map contents = json.decode(await file.readAsString());
      print(contents[key]);
      return contents[key];
    } catch (e) {
      // If encountering an error, return 0
      print(e);
    }
  }
}