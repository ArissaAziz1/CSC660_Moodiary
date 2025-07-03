// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart'; // Import the bottom navigation bar

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Navigate to settings page
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView( // Changed to ListView to accommodate more content
        padding: const EdgeInsets.all(16.0),
        children: [
          Center( // Center the avatar and name/email
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60, // Slightly larger avatar
                  backgroundColor: Colors.blue.withOpacity(0.2), // Light blue background
                  backgroundImage: const NetworkImage('https://placehold.co/120x120/ADD8E6/000000?text=Sarah'), // Placeholder image
                  child: const Icon(Icons.person, size: 60, color: Colors.blue), // Fallback icon
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'sarah.johnson@example.com',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Optional: Short bio/status
                const Text(
                  'Passionate about capturing life\'s moments.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Journaling Insights Section (NEW)
          _buildSectionHeader('Journaling Insights'),
          _buildInsightCard(
            context,
            icon: Icons.edit_note,
            title: 'Total Entries',
            value: '245', // Placeholder value
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Total Entries pressed!')),
              );
            },
          ),
          _buildInsightCard(
            context,
            icon: Icons.local_fire_department,
            title: 'Current Streak',
            value: '15 Days', // Placeholder value
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Current Streak pressed!')),
              );
            },
          ),
          _buildInsightCard(
            context,
            icon: Icons.mood,
            title: 'Dominant Mood',
            value: 'Happy 😊', // Placeholder value
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dominant Mood pressed!')),
              );
            },
          ),
          const SizedBox(height: 24),

          // Account Settings Section
          _buildSectionHeader('Account'),
          _buildProfileSection(
            context,
            icon: Icons.person_outline,
            title: 'Account Information',
            routeName: '/account', // Navigate to account information page
          ),
          _buildProfileSection(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // TODO: Implement change password flow
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password pressed!')),
              );
            },
          ),
          _buildProfileSection(
            context,
            icon: Icons.notifications_none,
            title: 'Notification Preferences',
            routeName: '/notifications', // Navigate to notification settings page
          ),
          _buildProfileSection(
            context,
            icon: Icons.security,
            title: 'Privacy Settings',
            routeName: '/privacy', // Navigate to privacy policy page
          ),
          const SizedBox(height: 24),

          // General Settings Section
          _buildSectionHeader('General'),
          _buildProfileSection(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Theme & Appearance',
            onTap: () {
              // TODO: Implement theme selection or dark mode toggle
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings pressed!')),
              );
            },
          ),
          _buildProfileSection(
            context,
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              // TODO: Implement language selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings pressed!')),
              );
            },
          ),
          const SizedBox(height: 24),

          // Data & Storage Section
          _buildSectionHeader('Data & Storage'),
          _buildProfileSection(
            context,
            icon: Icons.backup_outlined,
            title: 'Backup & Restore',
            onTap: () {
              // TODO: Implement data backup/restore functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup & Restore pressed!')),
              );
            },
          ),
          _buildProfileSection(
            context,
            icon: Icons.cloud_outlined,
            title: 'Sync Data',
            onTap: () {
              // TODO: Implement data synchronization
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync Data pressed!')),
              );
            },
          ),
          _buildProfileSection( // New: Export Data
            context,
            icon: Icons.download_for_offline_outlined,
            title: 'Export Data',
            onTap: () {
              // TODO: Implement data export functionality (e.g., PDF, JSON)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export Data pressed!')),
              );
            },
          ),
          const SizedBox(height: 24),

          // Support Section
          _buildSectionHeader('Support'),
          _buildProfileSection(
            context,
            icon: Icons.help_outline,
            title: 'Help Center',
            routeName: '/help', // Navigate to help center page
          ),
          _buildProfileSection(
            context,
            icon: Icons.info_outline,
            title: 'About Moodiary',
            onTap: () {
              // TODO: Show app version, legal info, etc.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('About Moodiary pressed!')),
              );
            },
          ),
          const SizedBox(height: 24), // Add some space at the bottom
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4), // Profile tab selected
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // Helper method to build individual profile sections/settings tiles
  Widget _buildProfileSection(BuildContext context, {
    required IconData icon,
    required String title,
    String? routeName, // Make routeName optional as some might use onTap directly
    VoidCallback? onTap, // Add onTap callback
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (routeName != null) {
            Navigator.pushNamed(context, routeName);
          } else if (onTap != null) {
            onTap(); // Use the provided onTap callback
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.black54),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an insight card
  Widget _buildInsightCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.blue), // Blue icon for insights
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
