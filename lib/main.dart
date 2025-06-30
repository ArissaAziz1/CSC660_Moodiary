import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart'; // Ensure this file exports a class named HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Keeper',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(), // Make sure HomePage is defined in home_page.dart
      },
    );
  }
}
