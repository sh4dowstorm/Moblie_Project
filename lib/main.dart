import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/firebase_options.dart';
import 'package:mobile_project/screens/login_screen.dart';
import 'package:mobile_project/screens/home_screen.dart';
import 'package:mobile_project/screens/main_layout_screen.dart';
import 'package:mobile_project/screens/setting_screen.dart';
import 'package:mobile_project/screens/edit_account_screen.dart';

Future<void> main() async {
  // initial firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayoutScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/setting': (context) => SettingScreen(),
        '/edit_account': (context) => EditAccountScreen(),
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
            fontWeight: FontWeight.w600,
            fontFamily: 'Prompt',
          ),
          labelMedium: TextStyle(
            color: Color(0xFF070A07),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Prompt',
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF070A07),
            fontSize: 24,
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
          onBackground: Color(0xFF070A07),
          onPrimary: Color(0xFF62A675),
          onSecondary: Colors.deepOrangeAccent,
          surface: Colors.white,
          background: Color(0xFFF3F8FF),
          primary: Color(0xFFDAEEE0),
          secondary: Color(0xFFA6CEB1),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
