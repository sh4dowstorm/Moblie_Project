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
            color: Color(0xFF070A07),
            fontSize: 32,
            fontWeight: FontWeight.w800,
            fontFamily: 'Prompt',
          ),
          titleMedium: TextStyle(
            color: Color(0xFF070A07),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Prompt',
          ),
          labelSmall: TextStyle(
            color: Color(0xFF070A07),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Prompt',
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

        // blackgroud, main, accent,... color
        colorScheme: const ColorScheme.light(
          background: Color(0xFFF3F8FF),
          primary: Color(0xFFDAEEE0),
          secondary: Color(0xFFA6CEB1),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
