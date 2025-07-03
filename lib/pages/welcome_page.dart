// lib/pages/welcome_page.dart
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // The background will be handled by the Container in the body
      backgroundColor: Colors.transparent, // Make scaffold transparent to show body's background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF89CFF0), // Light Blue
              Color(0xFFADD8E6), // Lighter Blue
              Color(0xFFE0FFFF), // Light Cyan
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Decorative Icon/Illustration
                Icon(
                  Icons.book_outlined, // A subtle icon related to journaling
                  size: screenSize.width * 0.25, // Responsive size
                  color: Colors.white.withOpacity(0.8), // Soft white color
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Welcome Text
                Text(
                  'Welcome to Moodiary', // More descriptive welcome
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.01),

                // Subtitle Text
                Text(
                  'Your personal space to save every moment and track your emotions.',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.white70, // Slightly transparent white
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.06),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton( // Changed to ElevatedButton for more prominence
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      foregroundColor: Colors.blue.shade700, // Darker blue text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      elevation: 8, // More prominent shadow
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton( // Changed to OutlinedButton for secondary action
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, // White text
                      side: const BorderSide(color: Colors.white, width: 1.5), // White border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Create Account', // More inviting text
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
