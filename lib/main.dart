import 'package:flutter/material.dart';
import 'package:flutter_assignment/LoginForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: LoginForm(),
      ),
    );
  }
}
