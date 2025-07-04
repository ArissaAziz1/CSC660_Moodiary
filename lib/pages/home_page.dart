// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Ensure this import is present for DateFormat
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/bottom_navbar.dart';
import '../theme/theme_notifier.dart';
import '../services/supabase_client.dart';

// Enum to represent sorting options for entries
enum SortOrder { latest, oldest }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SortOrder _selectedSortOrder = SortOrder.latest; // Default to latest
  List<Map<String, dynamic>> _entries = []; // List to store fetched entries
  bool _isLoadingEntries = true; // Loading state for entries

  @override
  void initState() {
    super.initState();
    _fetchEntries(); // Fetch entries when the page initializes
    // Listen for auth changes to re-fetch entries if user logs in/out
    supabase.auth.onAuthStateChange.listen((data) {
      if (mounted) { // Ensure widget is still mounted before calling setState
        if (data.event == AuthChangeEvent.signedIn || data.event == AuthChangeEvent.signedOut) {
          _fetchEntries();
        }
      }
    });
  }

  Future<void> _fetchEntries() async {
    setState(() {
      _isLoadingEntries = true;
    });

    final User? user = supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _entries = []; // Clear entries if no user is logged in
          _isLoadingEntries = false;
        });
      }
      return;
    }

    try {
      // Fetch entries from 'diary_entries' table for the current user
      final List<Map<String, dynamic>> data = await supabase
          .from('diary_entries')
          .select()
          .eq('user_id', user.id) // Filter by current user's ID
          .order('created_at', ascending: _selectedSortOrder == SortOrder.oldest); // Apply initial sort

      if (mounted) { // Check mounted before setState
        setState(() {
          _entries = data;
        });
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching entries: ${e.message}')),
        );
      }
      _entries = []; // Clear entries on error
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
      _entries = []; // Clear entries on error
    } finally {
      if (mounted) { // Check mounted before setState
        setState(() {
          _isLoadingEntries = false;
        });
      }
    }
  }

  // Method to sort the entries based on the selected option
  List<Map<String, dynamic>> _sortEntries(List<Map<String, dynamic>> entries) {
    entries.sort((a, b) {
      final DateTime timestampA = DateTime.parse(a['created_at']);
      final DateTime timestampB = DateTime.parse(b['created_at']);
      if (_selectedSortOrder == SortOrder.latest) {
        return timestampB.compareTo(timestampA); // Newest first
      } else {
        return timestampA.compareTo(timestampB); // Oldest first
      }
    });
    return entries;
  }

  // Delete Entry Function
  Future<void> _deleteEntry(String entryId) async {
    // Show confirmation dialog to prevent accidental deletions
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this entry? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // User cancels
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true), // User confirms
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // If the user confirmed the deletion
    if (confirmDelete == true) {
      try {
        // Perform the delete operation on Supabase for the given entryId
        await supabase.from('diary_entries').delete().eq('id', entryId);

        // Show a success message to the user
        if (mounted) { // Check mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entry deleted successfully!')),
          );
        }
        // Re-fetch entries to update the list on the UI
        _fetchEntries();
      } on PostgrestException catch (e) {
        // Handle Supabase-specific errors
        if (mounted) { // Check mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete entry: ${e.message}')),
          );
        }
      } catch (e) {
        // Handle any other unexpected errors
        if (mounted) { // Check mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort entries for display
    final List<Map<String, dynamic>> displayedEntries = _sortEntries(List.from(_entries));
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Moodiary', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              themeNotifier.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeNotifier.toggleTheme();
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
                _fetchEntries(); // Re-fetch with new sort order
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Greeting Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary.withOpacity(0.7), Theme.of(context).colorScheme.primary],
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
                    "Hello Arissa!", // TODO: Fetch real user name
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                        // Navigate to entry editor for creating a NEW entry
                        Navigator.pushNamed(context, '/entry');
                      },
                      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                      label: Text('New Entry', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
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
              height: 160,
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
            _isLoadingEntries
                ? const Center(child: CircularProgressIndicator())
                : displayedEntries.isEmpty
                    ? Center(
                        child: Text(
                          'No entries found. Start by adding a new one!',
                          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        children: displayedEntries.map((entry) {
                          final DateTime entryTimestamp = DateTime.parse(entry['created_at']);
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).cardColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                // TODO: Implement navigation to a detailed entry view page if needed
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('View Entry ${entry['title']} pressed!')),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry['image_url'] != null)
                                    Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(entry['image_url']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('dd MMMMyyyy').format(entryTimestamp), // Corrected date format
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
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                entry['title'] ?? 'No Title',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // --- Edit and Delete Buttons ---
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                              onPressed: () async {
                                                // Navigate to entry editor for EDITING an existing entry
                                                await Navigator.pushNamed(
                                                  context,
                                                  '/entry',
                                                  arguments: entry, // Pass the entire entry map as arguments
                                                );
                                                _fetchEntries(); // Refresh entries after editing
                                              },
                                              tooltip: 'Edit Entry',
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red.shade400),
                                              onPressed: () => _deleteEntry(entry['id']), // Pass the entry ID
                                              tooltip: 'Delete Entry',
                                            ),
                                            // --- End Edit and Delete Buttons ---
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              entry['mood_emoji'] ?? '📝',
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                entry['content'] ?? 'No content preview available.',
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
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Read More for Entry ${entry['title']}')),
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // Helper methods (unchanged from previous versions)
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderSide.color,
            width: borderSide.width,
          ),
          boxShadow: [
            if (isLatest)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            if (!isLatest)
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
              isLatest ? Icons.arrow_downward : Icons.arrow_upward,
              size: 18,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSummaryCard(
      BuildContext context, String title, String moodText, String emoji, Color bgColor, Color textColor) {
    return Container(
      width: 150,
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
            style: const TextStyle(fontSize: 40),
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
