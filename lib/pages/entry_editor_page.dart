import 'package:flutter/material.dart';

class WriteEntryScreen extends StatelessWidget {
  const WriteEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [
          Icon(Icons.undo, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.redo, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.check, color: Colors.blue),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Row(
              children: const [
                Text("15", style: TextStyle(fontSize: 20)),
                SizedBox(width: 12),
                Text("March 2025", style: TextStyle(fontSize: 20)),
                Icon(Icons.favorite, color: Colors.redAccent),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Tuesday", style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Write more...',
                border: InputBorder.none,
              ),
              maxLines: 6,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blueGrey[100],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.edit),
            Icon(Icons.text_fields),
            Icon(Icons.format_align_left),
            Icon(Icons.image),
            Icon(Icons.label),
            Icon(Icons.mic),
            Icon(Icons.emoji_emotions),
          ],
        ),
      ),
    );
  }
}
