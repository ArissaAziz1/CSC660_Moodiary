// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../widgets/bottom_navbar.dart'; // Import the bottom navigation bar
import 'package:intl/intl.dart'; // For date formatting
import '../theme/theme_notifier.dart'; // Import your ThemeNotifier

// Enum to represent sorting options for entries
enum SortOrder { latest, oldest }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SortOrder _selectedSortOrder = SortOrder.latest; // Default to latest

  // Placeholder data for recent entries
  // In a real app, this would come from your diary entries database
  final List<Map<String, dynamic>> _recentEntries = List.generate(
    7, // Example number of entries
    (index) {
      return {
        'id': index,
        'title': 'Entry Title ${index + 1}',
        'content': 'This is a short preview of the diary entry. It can contain a few lines of text...',
        'timestamp': DateTime.now().subtract(Duration(days: index * 2)), // Dummy time for sorting
        'mood': index % 3 == 0 ? '😊' : (index % 3 == 1 ? '😔' : '😄'), // Dummy moods
        'imageUrl': 'https://placehold.co/600x400/ADD8E6/000000?text=Entry+Pic+${index + 1}', // Dummy image URL
      };
    },
  );

  // Method to sort the entries based on the selected option
  List<Map<String, dynamic>> _sortEntries(List<Map<String, dynamic>> entries) {
    entries.sort((a, b) {
      if (_selectedSortOrder == SortOrder.latest) {
        return b['timestamp'].compareTo(a['timestamp']); // Newest first
      } else {
        return a['timestamp'].compareTo(b['timestamp']); // Oldest first
      }
    });
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sortedEntries = _sortEntries(List.from(_recentEntries)); // Create a mutable copy
    final themeNotifier = Provider.of<ThemeNotifier>(context); // Access the ThemeNotifier

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background, // Use theme background color
      appBar: AppBar(
        title: const Text('Moodiary', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.onSurface, // Adjust icon color based on theme
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeNotifier.toggleTheme(); // Call the toggle method
            },
          ),
          const SizedBox(width: 8),
          // Sort Button for Latest/Oldest
          _buildSortButton(
            context,
            label: _selectedSortOrder == SortOrder.latest ? 'Latest' : 'Oldest',
            onTap: () {
              setState(() {
                _selectedSortOrder = _selectedSortOrder == SortOrder.latest ? SortOrder.oldest : SortOrder.latest;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sorted by ${_selectedSortOrder == SortOrder.latest ? 'Latest' : 'Oldest'}')),
              );
            },
          ),
          const SizedBox(width: 16), // Add some spacing at the end
        ],
      ),
      body: SingleChildScrollView( // Wrap the body in SingleChildScrollView for overall scrollability
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Greeting Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary.withOpacity(0.7), Theme.of(context).colorScheme.primary], // Use theme primary color
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello Sarah!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary, // Text color on primary background
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ready to capture your thoughts?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/entry'); // Navigate to entry editor
                      },
                      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                      label: Text('New Entry', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface, // Use theme surface color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card stack (Mood Summary / Quick Insights)
            Text(
              "Your Mood at a Glance",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160, // Adjusted height for more compact cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildMoodSummaryCard(context, 'Today', 'Happy', '😊', Colors.green.shade100, Colors.green.shade700),
                  _buildMoodSummaryCard(context, 'This Week', 'Mixed', '😐', Colors.orange.shade100, Colors.orange.shade700),
                  _buildMoodSummaryCard(context, 'This Month', 'Calm', '😌', Colors.purple.shade100, Colors.purple.shade700),
                  _buildMoodSummaryCard(context, 'Last Entry', 'Thoughtful', '🤔', Colors.blue.shade100, Colors.blue.shade700),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Recent Entries",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            Column( // Use Column directly within SingleChildScrollView
              children: sortedEntries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3, // Slightly more prominent shadow
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // More rounded corners
                  clipBehavior: Clip.antiAlias, // Clip image to card shape
                  color: Theme.of(context).cardColor, // Use theme card color
                  child: InkWell( // Add InkWell for ripple effect on tap
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      // TODO: Navigate to full entry view
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('View Entry ${entry['id'] + 1} pressed!')),
                      );
                    },
                    child: Column( // Changed from Padding to Column to place image on top
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the image if available
                        if (entry['imageUrl'] != null)
                          Container(
                            height: 180, // Fixed height for the image
                            width: double.infinity, // Take full width
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(entry['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat('dd MMMM yyyy').format(entry['timestamp']), // Corrected format: 'dd MMMM yyyy'
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Padding( // Wrap the rest of the content in Padding
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded( // Ensure title doesn't overflow
                                    child: Text(
                                      entry['title'],
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Removed date here as it's now on the image
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    entry['mood'], // Display mood emoji
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      entry['content'],
                                      style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to full entry view
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Read More for Entry ${entry['id'] + 1}')),
                                    );
                                  },
                                  child: const Text('Read More', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      // Use the custom BottomNavBar
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // Helper method to build a cute sort button (similar to GalleryScreen)
  Widget _buildSortButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isLatest = _selectedSortOrder == SortOrder.latest;
    final Color textColor = isLatest ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface;
    final Color iconColor = isLatest ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface;
    final Color backgroundColor = isLatest ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Theme.of(context).colorScheme.surface;
    final BorderSide borderSide = BorderSide(
      color: isLatest ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
      width: isLatest ? 1.5 : 1.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20), // More rounded for a "cute" look
          border: Border.all(
            color: borderSide.color,
            width: borderSide.width,
          ),
          boxShadow: [
            if (isLatest) // Apply shadow only if 'Latest' is selected
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            if (!isLatest) // Apply a subtle shadow if not selected
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isLatest ? Icons.arrow_downward : Icons.arrow_upward, // Down for latest, Up for oldest
              size: 18,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a mood summary card
  Widget _buildMoodSummaryCard(
      BuildContext context, String title, String moodText, String emoji, Color bgColor, Color textColor) {
    return Container(
      width: 150, // Fixed width for each card
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            emoji,
            style: const TextStyle(fontSize: 40), // Large emoji
          ),
          Text(
            moodText,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
