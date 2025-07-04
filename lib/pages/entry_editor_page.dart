// lib/pages/entry_editor_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_client.dart';

class WriteEntryScreen extends StatefulWidget {
  const WriteEntryScreen({super.key});

  @override
  State<WriteEntryScreen> createState() => _WriteEntryScreenState();
}

class _WriteEntryScreenState extends State<WriteEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedEmoji;
  File? _selectedImage;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Show Emoji Picker
  void _showEmojiPicker() {
    final List<String> emojis = [
      '😀','😃','😄','😁','😆','😅','🤣','😂','🙂','🙃','😉','😊',
      '🥰','🤩','😘','😗','😚','😙','😋','😛','😜','🤪','😝',
      '🤑','🤗','🤭','🤫','🤔','🤐','🤨','😐','😑','😶'
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            final emoji = emojis[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedEmoji = emoji;
                });
                Navigator.pop(context);
              },
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
            );
          },
        );
      },
    );
  }

  // Pick Image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Save Entry
  Future<void> _saveEntry() async {
    setState(() {
      _isSaving = true;
    });

    final user = supabase.auth.currentUser;
    if (user == null) {
      _showMessage('You must be logged in.');
      setState(() {
        _isSaving = false;
      });
      return;
    }

    String? imageUrl;
    if (_selectedImage != null) {
      try {
        final fileName = '${user.id}/${DateTime.now().millisecondsSinceEpoch}${p.extension(_selectedImage!.path)}';
        await supabase.storage
            .from('moodiary')
            .upload(fileName, _selectedImage!, fileOptions: const FileOptions(upsert: true));

        imageUrl = supabase.storage.from('moodiary').getPublicUrl(fileName);
      } catch (e) {
        _showMessage('Image upload failed: $e');
        setState(() {
          _isSaving = false;
        });
        return;
      }
    }

    final now = DateTime.now();

    try {
      await supabase.from('diary_entries').insert({
        'user_id': user.id,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'mood_emoji': _selectedEmoji,
        'image_url': imageUrl,
        'created_at': now.toIso8601String(), // Save timestamp
      });

      _showMessage('Entry saved successfully!');
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Error saving entry: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final dateLabel = DateFormat('EEEE, MMMM d, yyyy').format(date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Diary Entry'),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveEntry,
                )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 8),
                Text(dateLabel, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                _selectedEmoji != null
                    ? Text(_selectedEmoji!, style: const TextStyle(fontSize: 28))
                    : IconButton(
                        icon: const Icon(Icons.emoji_emotions_outlined),
                        onPressed: _showEmojiPicker,
                      )
              ],
            ),
            const SizedBox(height: 20),
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Content
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Write your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
            ),
            const SizedBox(height: 16),
            // Image Preview
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_selectedImage!, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            // Add Image Button
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Add Image'),
            ),
          ],
        ),
      ),
    );
  }
}
