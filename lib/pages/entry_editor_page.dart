// lib/pages/entry_editor_page.dart
import 'package:flutter/material.dart';
// No need to import bottom_navbar here as it's not directly used in this page's scaffold

class WriteEntryScreen extends StatefulWidget {
  const WriteEntryScreen({super.key});

  @override
  State<WriteEntryScreen> createState() => _WriteEntryScreenState();
}

class _WriteEntryScreenState extends State<WriteEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedEmoji; // State variable to hold the selected emoji

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Method to show the emoji picker bottom sheet
  void _showEmojiPicker() {
    final List<String> emojis = [
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
      '😉', '😊', '😇', '🥰', '🤩', '😘', '😗', '😚', '😙', '😋',
      '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐',
      '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥', '😌',
      '😔', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮', '🤧', '🥵',
      '🥶', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😕', '😟',
      '🙁', '☹️', '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨',
      '😰', '😥', '😢', '😭', '😱', '😖', '😣', '😩', '😫', '😤',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take more height if needed
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Start at half screen height
          minChildSize: 0.3,
          maxChildSize: 0.9, // Can expand up to 90% of screen height
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose Mood/Emoji',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, // Number of emojis per row
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: emojis.length,
                      itemBuilder: (context, index) {
                        final emoji = emojis[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedEmoji = emoji; // Set the selected emoji
                            });
                            Navigator.pop(context); // Close the bottom sheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected: $emoji')),
                            );
                          },
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 30), // Larger emoji size
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Undo pressed!')),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Redo pressed!')),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              // TODO: Implement save functionality with _titleController.text, _contentController.text, _selectedEmoji
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Entry saved! Title: "${_titleController.text}", Emoji: ${_selectedEmoji ?? "None"}',
                  ),
                ),
              );
              // Optionally pop back after saving
              // Navigator.pop(context);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Mood
            Row(
              children: [
                const Text("15", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                const Text("March 2025", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                if (_selectedEmoji != null) // Display selected emoji if available
                  Text(
                    _selectedEmoji!,
                    style: const TextStyle(fontSize: 24),
                  )
                else
                  const Icon(Icons.mood, color: Colors.grey, size: 24), // Default mood icon
              ],
            ),
            const SizedBox(height: 8),
            const Text("Tuesday", style: TextStyle(fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 20),
            TextField(
              controller: _titleController, // Assign controller
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 1,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController, // Assign controller
                decoration: const InputDecoration(
                  hintText: 'Write more...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildToolbarIcon(Icons.edit, 'Edit', () { /* TODO: Implement edit functionality */ }),
            _buildToolbarIcon(Icons.text_fields, 'Text', () { /* TODO: Implement text formatting */ }),
            _buildToolbarIcon(Icons.format_align_left, 'Align', () { /* TODO: Implement alignment */ }),
            _buildToolbarIcon(Icons.image, 'Image', () { /* TODO: Implement image attachment */ }),
            _buildToolbarIcon(Icons.label, 'Tag', () { /* TODO: Implement tagging */ }),
            _buildToolbarIcon(Icons.mic, 'Voice', () { /* TODO: Implement voice recording */ }),
            _buildToolbarIcon(Icons.emoji_emotions, 'Emoji', _showEmojiPicker), // Connect to emoji picker
          ],
        ),
      ),
    );
  }

  // Helper method to build toolbar icons
  Widget _buildToolbarIcon(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black54),
      tooltip: tooltip,
      onPressed: onPressed, // Use the provided onPressed callback
    );
  }
}
