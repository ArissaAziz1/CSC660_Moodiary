// lib/widgets/bottom_navbar.dart
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue, // Using primary color for selected item
      unselectedItemColor: Colors.grey[600], // Slightly darker grey for unselected
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed, // Ensures all items are visible
      onTap: (index) {
        // Handle navigation based on the tapped index
        switch (index) {
          case 0: // Home
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1: // Calendar
            Navigator.pushReplacementNamed(context, '/calendar');
            break;
          case 2: // Entry (Center Add Button)
            // Use pushNamed for the entry editor so it can be popped back to the previous screen
            Navigator.pushNamed(context, '/entry');
            break;
          case 3: // Gallery
            Navigator.pushReplacementNamed(context, '/gallery');
            break;
          case 4: // Profile
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: "Add Entry"), // Larger icon for center
        BottomNavigationBarItem(icon: Icon(Icons.image), label: "Gallery"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
