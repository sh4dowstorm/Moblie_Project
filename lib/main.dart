import 'package:flutter/material.dart';
import 'package:mobile_project/screens/login_screen.dart';
import 'package:mobile_project/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}
