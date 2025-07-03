// lib/pages/calendar_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart'; // Import the bottom navigation bar
import 'package:intl/intl.dart'; // For date formatting

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Initialize with the current month and year
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background, // Use theme background color
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)), // Adaptive title color
        actions: const [
          // Removed the filter button and its SizedBox
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, size: 30, color: Theme.of(context).colorScheme.onSurface), // Adaptive icon color
                onPressed: () {
                  setState(() {
                    // Navigate to the previous month
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                  });
                },
              ),
              const SizedBox(width: 8),
              // Display the current month and year dynamically
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth), // Corrected format: 'MMMM yyyy'
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground), // Adaptive text color
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.arrow_right, size: 30, color: Theme.of(context).colorScheme.onSurface), // Adaptive icon color
                onPressed: () {
                  setState(() {
                    // Navigate to the next month
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Day of week headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Text('Sun', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Mon', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Tue', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Wed', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Thu', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Fri', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
                Text('Sat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)), // Adaptive text color
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).colorScheme.outline), // Adaptive divider color

          // Calendar Grid
          Expanded(child: _buildCalendar()),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1), // Pass the current index
    );
  }

  Widget _buildCalendar() {
    // Calculate the number of days in the current month
    final int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    // Calculate the weekday of the first day of the current month (1=Monday, ..., 7=Sunday)
    final int firstDayWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    List<Widget> calendarDays = [];

    // Add empty containers for days before the 1st of the month
    final int leadingEmptyCells = firstDayWeekday % 7;

    for (int i = 0; i < leadingEmptyCells; i++) {
      calendarDays.add(Container());
    }

    // Add actual days
    for (int day = 1; day <= daysInMonth; day++) {
      // Create a DateTime object for the current day being rendered
      final DateTime date = DateTime(_currentMonth.year, _currentMonth.month, day);
      // Logic to check if the current day being rendered is today's date
      final bool isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;

      calendarDays.add(
        GestureDetector(
          onTap: () {
            // TODO: Handle day tap, e.g., show entries for that specific date
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped day ${DateFormat('dd MMMM yyyy').format(date)}')), // Corrected format here too
            );
          },
          child: Container(
            margin: const EdgeInsets.all(2), // Reduced margin
            decoration: BoxDecoration(
              color: isToday ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent, // Highlight today
              borderRadius: BorderRadius.circular(8),
              border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) : null, // Adaptive border color
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground, // Adaptive text color
                    ),
                  ),
                  // Example emojis for specific days (you'd replace this with actual entry data)
                  if (day == 5 || day == 15)
                    const Text("😊", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        crossAxisCount: 7,
        childAspectRatio: 1.4, // Adjusted for better fit
        children: calendarDays,
      ),
    );
  }
}
