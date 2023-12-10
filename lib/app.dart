import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/style.dart';

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(

        ///this is used for input type style ---------------->>>>>>>>>>>
        inputDecorationTheme: InputDecorationTheme(
            fillColor: colorWhite,
            filled: true,
            labelStyle: const TextStyle(
              color: colorGray,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            )
        ),
        ///--------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          )
        ),

        primaryColor: colorGreen,
        primarySwatch: Colors.green,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
      ),
    );
  }
}
