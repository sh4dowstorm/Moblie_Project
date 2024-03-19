import 'package:flutter/material.dart';
import 'package:mobile_project/models/location.dart';
import 'package:mobile_project/screens/login_screen.dart';
import 'package:mobile_project/screens/home_screen.dart';
import 'package:mobile_project/screens/place_detail_screen.dart';
import 'package:mobile_project/screens/setting_screen.dart';
import 'package:mobile_project/screens/edit_account_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/detail': (context) => PlaceDetailScreen(
              place: Place(
                name: 'เกาะมุก',
                located: 'ตำบลเกาะลิบง',
                imagePath: 'mook-island.jpg',
                category: PlaceCategory.beach,
                rated: 4.8,
                description:
                    '\t\tเกาะที่ใหญ่เป็นอันดับ 3 ของ ทะเลตรัง นั่นก็คือเกาะมุกที่สวยและเงียบสงบเหมือนกับเป็นเกาะส่วนตัว เลยก็ว่าได้ บนเกาะจะมีชาวบ้านอาศัยอยู่ โดยยังคงวิถีชีวิตในแบบเรียบง่าย ส่วนใหญ่แล้วนักท่องเที่ยวจะนิยมไปเที่ยวกันที่หาดฝรั่งและหาดสบายซึ่งสองหาดนี้ก็จะมีนิยมเที่ยวแบบที่ต่างกันไป\n\n \t\tในส่วนของหาดฝรั่งจะเป็นหาดที่มีที่พักเรียงรายอยู่บนพื้นทรายสีขาวนวลอย่างสวยงาม และเป็นจุดที่จะมีบริการนำเที่ยวต่างๆ ด้วย ส่วนหาดสบายนั้น จะสีขาวสวยเน้นความเงียบสงบ ที่นักท่องเที่ยวจะมานอนอาบแดดกันมากกว่า\n\n\t\tเกาะที่ใหญ่เป็นอันดับ 3 ของ ทะเลตรัง นั่นก็คือเกาะมุกที่สวยและเงียบสงบเหมือนกับเป็นเกาะส่วนตัว เลยก็ว่าได้ บนเกาะจะมีชาวบ้านอาศัยอยู่ โดยยังคงวิถีชีวิตในแบบเรียบง่าย ส่วนใหญ่แล้วนักท่องเที่ยวจะนิยมไปเที่ยวกันที่หาดฝรั่งและหาดสบายซึ่งสองหาดนี้ก็จะมีนิยมเที่ยวแบบที่ต่างกันไป\n\n \t\tในส่วนของหาดฝรั่งจะเป็นหาดที่มีที่พักเรียงรายอยู่บนพื้นทรายสีขาวนวลอย่างสวยงาม และเป็นจุดที่จะมีบริการนำเที่ยวต่างๆ ด้วย ส่วนหาดสบายนั้น จะสีขาวสวยเน้นความเงียบสงบ ที่นักท่องเที่ยวจะมานอนอาบแดดกันมากกว่า\n\n\t\tเกาะที่ใหญ่เป็นอันดับ 3 ของ ทะเลตรัง นั่นก็คือเกาะมุกที่สวยและเงียบสงบเหมือนกับเป็นเกาะส่วนตัว เลยก็ว่าได้ บนเกาะจะมีชาวบ้านอาศัยอยู่ โดยยังคงวิถีชีวิตในแบบเรียบง่าย ส่วนใหญ่แล้วนักท่องเที่ยวจะนิยมไปเที่ยวกันที่หาดฝรั่งและหาดสบายซึ่งสองหาดนี้ก็จะมีนิยมเที่ยวแบบที่ต่างกันไป\n\n \t\tในส่วนของหาดฝรั่งจะเป็นหาดที่มีที่พักเรียงรายอยู่บนพื้นทรายสีขาวนวลอย่างสวยงาม และเป็นจุดที่จะมีบริการนำเที่ยวต่างๆ ด้วย ส่วนหาดสบายนั้น จะสีขาวสวยเน้นความเงียบสงบ ที่นักท่องเที่ยวจะมานอนอาบแดดกันมากกว่า',
              ),
            ),
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
          background: Color(0xFFF3F8FF),
          primary: Color(0xFFDAEEE0),
          secondary: Color(0xFFA6CEB1),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
