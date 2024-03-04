import 'package:flutter/material.dart';
import 'package:mobile_project/pages/login_screen.dart';
import 'package:mobile_project/pages/home_screen.dart';

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
