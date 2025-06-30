import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.image), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: const [
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.arrow_left),
              SizedBox(width: 8),
              Text("March 2025", style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Icon(Icons.arrow_right),
            ],
          ),
          const SizedBox(height: 16),

          // Calendar Grid
          _buildCalendar(),

          const Spacer(),

          // Bottom NavBar
          BottomNavBar(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final days = List.generate(31, (index) => index + 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        shrinkWrap: true,
        children: days.map((day) {
          return Center(
            child: Column(
              children: [
                Text('$day'),
                if (day == 2)
                  const Text("😍", style: TextStyle(fontSize: 18)),
                if (day == 11)
                  const Text("😁", style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
