import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // <--- ADD THIS IMPORT for json.decode

import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart' as home_page;
import 'pages/calendar_page.dart';
import 'pages/entry_editor_page.dart'; // Make sure WriteEntryScreen is defined in this file
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/account_page.dart';
import 'pages/notifications_page.dart';
import 'pages/gallery_page.dart';
import 'theme/theme_notifier.dart';
// ignore: unused_import
import 'services/supabase_client.dart'; // Import your Supabase client instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for Supabase initialization

  // Initialize Supabase using the global __supabase_config
  // This configuration is provided by the Canvas environment.
  // Correctly parse the JSON string from __supabase_config
  final Map<String, dynamic> supabaseConfig =
      (const String.fromEnvironment('SUPABASE_CONFIG_JSON').isNotEmpty)
          ? json.decode(const String.fromEnvironment('SUPABASE_CONFIG_JSON')) as Map<String, dynamic>
          : {
              // Fallback for local development if not running in Canvas
              'url': 'https://eadhjhupwlbpteygfzoi.supabase.co', // REPLACE WITH YOUR ACTUAL SUPABASE URL
              'anonKey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhZGhqaHVwd2xicHRleWdmem9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1NzUyNjYsImV4cCI6MjA2NzE1MTI2Nn0.F9_rpqBT2rxQET59Gxlx5lbAI48HRHnr7g2BVySqPds', // REPLACE WITH YOUR ACTUAL SUPABASE ANON KEY
            };


  await Supabase.initialize(
    url: supabaseConfig['url']!,
    anonKey: supabaseConfig['anonKey']!,
    debug: true, // Set to false in production
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MoodiaryApp(),
    ),
  );
}

class MoodiaryApp extends StatelessWidget {
  const MoodiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Moodiary',
      themeMode: themeNotifier.themeMode,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.greenAccent,
          surface: Colors.grey[100]!,
          background: Colors.grey[100]!,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade300,
          secondary: Colors.greenAccent,
          surface: Colors.grey[800]!,
          background: Colors.grey[900]!,
          brightness: Brightness.dark,
        ),
        cardColor: Colors.grey[850],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const home_page.HomePage(),
        '/calendar': (context) => const CalendarScreen(),
        '/entry': (context) => WriteEntryScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/account': (context) => const AccountPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/gallery': (context) => GalleryScreen(),
        '/privacy': (context) => const PlaceholderPage(title: 'Privacy Policy'),
        '/help': (context) => const PlaceholderPage(title: 'Help Center'),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('This is the $title page.'),
      ),
    );
  }
}
