import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 for formatting date nicely

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _notes = []; // ✅ Note with text + date

  void _submitNote() {
    String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      final String formattedDate = DateFormat('MMM d, yyyy - h:mm a').format(DateTime.now());
      setState(() {
        _notes.add({
          'text': noteText,
          'date': formattedDate,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved!')),
      );
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Add a quick note:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Enter note...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save Note'),
            ),
            const SizedBox(height: 24),

            // ✅ Display saved notes
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('No notes added yet.'))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.note),
                            title: Text(note['text'] ?? ''),
                            subtitle: Text(note['date'] ?? ''),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
