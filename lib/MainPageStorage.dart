import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class MainPageStorage extends StatefulWidget {
  @override
	MainPageStorageState createState() {
    return MainPageStorageState();
  }
}

class MainPageStorageState extends State<MainPageStorage> {

  String txt;

  @override
  void initState() {
    super.initState();
    readFile('email').then((String value) {
      txt = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MainPage')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              Text('Account Info: $txt'),
              RaisedButton(
                onPressed: () => readFile('userId'),
                child: Text('data'),
              ),
            ],
          ),
        )
        
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
      // final data_json = jsonDecode(contents);
      setState(() {
       txt = contents[key]; 
      });
      print(contents);
      print(contents[key]);
      return contents[key];
    } catch (e) {
      print(e);
    }
  }

}