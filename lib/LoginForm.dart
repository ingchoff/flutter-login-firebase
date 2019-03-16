import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/MainPageStorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_assignment/MainPage.dart';
import 'package:flutter_assignment/RegisForm.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
	@override
	LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
	final _formKey = GlobalKey<FormState>();
  final textValue1 = TextEditingController();
  final textValue2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    textValue1.clear();
    textValue2.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Image.asset('resources/img.jpg',height: 250,),
          ),  
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please, enter Email';
                }
              },
              controller: textValue1,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: TextFormField(
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please, enter password';
                }
              },
              controller: textValue2,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.https),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              obscureText: true,
              ),
          ),   
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: signIn,
                child: setUpButtonChild(),
                color: Colors.lightBlueAccent,
              ),
            )
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterForm()));
              },
            child: Text('Register New Account',style: TextStyle(color: Colors.teal, fontSize: 16),textAlign: TextAlign.right,),
          ),
          // _showCircularProgress(),
        ]
      )
    );
  }

  Widget setUpButtonChild() {
    if (_isLoading) {
      return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),);
    }else {
      return new Text('LOGIN');
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          title: new Text("Please, Verify Email"),
          content: new Text("โปรดยืนยัน Email ก่อนเข้าสู่ระบบ"),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              color: Colors.lightBlueAccent,
              child: new Text("OK",style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() {
       _isLoading = true; 
      });
      try{
        // Login
        FirebaseUser user = await _auth.signInWithEmailAndPassword(email: textValue1.text, password: textValue2.text);
        if (user.isEmailVerified) {
          setState(() {
          _isLoading = false;
          });
          writeFile(user);
          //ถ้า Login สำเร็จจะไปที่หน้าหลักโดยมีการส่งค่า user ที่ login ไปหน้าหลัก
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(user: user)));
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageStorage()));
        } else {
          setState(() {
            _isLoading = false;
          });
          _showDialog();
        }
      }catch(e){
        print(e.message);
        setState(() {
         _isLoading = false;
        });
        if(e.message == 'The email address is badly formatted.') {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Email ไม่ถูกต้อง'),
          ));
        } else if(e.message == 'The password is invalid or the user does not have a password.') {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Password ไม่ถูกต้อง'),
          ));
        } else if(e.message == 'There is no user record corresponding to this identifier. The user may have been deleted.') {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('ไม่พบ Email นี้ในระบบ'),
          ));
        }
      }
    }
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
  //เก็บค่า uid และ email ไว้ในไฟล์ data.txt
  Future<File> writeFile(user) async {
    final file = await _localFile;
    String data = '{"userId":'+'"'+user.uid+'"'+',"email":"'+user.email+'"}';
    print(data);
    // Write the file
    return file.writeAsString(data);
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