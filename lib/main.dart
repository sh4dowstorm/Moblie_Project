import 'package:flutter/material.dart';
import 'package:mobile_project/pages/login_screen.dart';
import 'package:mobile_project/pages/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
      theme: ThemeData(
        // text theme
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
        ),

        // search bar theme
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          prefixIconColor: Color(0xFF9DB1A3),
          hintStyle: TextStyle(
            color: Color(0xFF9DB1A3),
            fontSize: 15,
          ),
        ),

        // icon button theme
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconSize: MaterialStatePropertyAll(30),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
