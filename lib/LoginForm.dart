import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assignment/MainPage.dart';
import 'package:flutter_assignment/RegisForm.dart';

// final GoogleSignIn _googleSignIn = GoogleSignIn();
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
    // This also removes the _printLatestValue listener
    textValue1.dispose();
    textValue2.dispose();
    super.dispose();
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
                }else if(value == 'admin') {
                  return 'not permission';
                }
              },
              controller: textValue1,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextFormField(
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please, enter password';
                }else if(value == 'admin'){
                  return 'not permission';
                }
              },
              controller: textValue2,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.https)
              ),
              obscureText: true,
              ),
          ),   
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 50,
              child: RaisedButton(
                onPressed: signIn,
                child: setUpButtonChild(),
              ),
            )
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterForm()));
              },
            child: Text('Register New Account',style: TextStyle(color: Colors.teal),textAlign: TextAlign.right,),
          ),
          // _showCircularProgress(),
        ]
      )
    );
  }

  Widget setUpButtonChild() {
    if (_isLoading) {
      return CircularProgressIndicator();
    }else {
      return new Text('LOGIN');
    }
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() {
       _isLoading = true; 
      });
      try{
        await _auth.signInWithEmailAndPassword(email: textValue1.text, password: textValue2.text);
        setState(() {
         _isLoading = false; 
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
      }catch(e){
        print(e.message);
        setState(() {
         _isLoading = false;
        });
        if(e.message == 'The email address is badly formatted.') {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Email ไม่ถูกต้อง'),
          ));
        }else if(e.message == 'The password is invalid or the user does not have a password.') {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Password ไม่ถูกต้อง'),
          ));
        }
      }
    }
  }
}