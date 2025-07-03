import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <--- ADD THIS IMPORT
import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/entry_editor_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/account_page.dart';
import 'pages/notifications_page.dart';
import 'pages/gallery_page.dart';
import 'theme/theme_notifier.dart'; // <--- ADD THIS IMPORT

void main() {
  runApp(
    ChangeNotifierProvider( // <--- WRAP YOUR APP WITH THIS
      create: (context) => ThemeNotifier(), // <--- CREATE AN INSTANCE OF YOUR THEME NOTIFIER
      child: const MoodiaryApp(),
    ),
  );
}

class MoodiaryApp extends StatelessWidget {
  const MoodiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // <--- ACCESS THE THEMENOTIFIER HERE
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Moodiary',
      themeMode: themeNotifier.themeMode, // <--- USE THE THEME MODE FROM THE NOTIFIER
      theme: ThemeData( // Your existing LIGHT theme definition
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue, // Material 2 concept, consider colorScheme for M3
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
          brightness: Brightness.light, // Explicitly define brightness for light theme
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData( // <--- DEFINE YOUR DARK THEME HERE
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue, // Material 2 concept
        scaffoldBackgroundColor: Colors.grey[900], // Dark background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white, // White icons/text for dark mode app bar
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade300, // Lighter blue for dark mode primary
          secondary: Colors.greenAccent,
          surface: Colors.grey[800]!, // Darker surface for cards/sheets
          background: Colors.grey[900]!,
          brightness: Brightness.dark, // Explicitly define brightness for dark theme
        ),
        // You might want to adjust other colors like text, card, etc. for dark mode
        cardColor: Colors.grey[850], // Darker card background
        textTheme: const TextTheme( // Define text colors for dark mode
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          // Add more text styles if needed, e.g., displayLarge, headlineMedium, etc.
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Default icon color for dark mode
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
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
