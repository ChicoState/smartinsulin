import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user_log_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _mealController = TextEditingController();

  final List<Map<String, String>> _notes = [];
  final List<Map<String, String>> _meals = [];

  String _selectedMood = '🙂';
  final List<String> moods = ['😊', '🙂', '😐', '😢', '😡'];

  void _submitNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      final time = DateFormat('MMM d, yyyy - h:mm a').format(DateTime.now());

      setState(() {
        _notes.add({'text': text, 'date': time, 'mood': _selectedMood});
      });

      // ✅ Log note to shared service
      UserLogService.notesData.add({
        'date': time,
        'note': text,
      });

      _noteController.clear();
    }
  }

  void _submitMeal() {
    final text = _mealController.text.trim();
    if (text.isNotEmpty) {
      final time = DateFormat('MMM d, yyyy - h:mm a').format(DateTime.now());

      setState(() {
        _meals.add({'text': text, 'date': time});
      });

      // ✅ Log meal to shared service
      UserLogService.mealData.add({
        'date': time,
        'text': text,
      });

      _mealController.clear();
    }
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: moods.map((emoji) {
        final isSelected = _selectedMood == emoji;
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = emoji),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade100 : Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green.shade600 : Colors.grey,
                width: 2,
              ),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Note'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionHeader('How are you feeling?'),
            _buildMoodSelector(),

            const SizedBox(height: 24),
            const Text('Write a note:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Enter your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save Note', style: TextStyle(color: Colors.white)),
            ),

            _buildSectionHeader('Your Notes'),
            if (_notes.isEmpty)
              const Text('No notes yet.')
            else
              ..._notes.map((note) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Text(note['mood'] ?? '', style: const TextStyle(fontSize: 24)),
                      title: Text(note['text'] ?? ''),
                      subtitle: Text(note['date'] ?? ''),
                    ),
                  )),

            _buildSectionHeader('Log Your Meals'),
            TextField(
              controller: _mealController,
              decoration: const InputDecoration(
                hintText: 'What did you eat?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitMeal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save Meal', style: TextStyle(color: Colors.white)),
            ),

            _buildSectionHeader('Meal Log'),
            if (_meals.isEmpty)
              const Text('No meals logged yet.')
            else
              ..._meals.map((meal) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.restaurant_menu),
                      title: Text(meal['text'] ?? ''),
                      subtitle: Text(meal['date'] ?? ''),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
