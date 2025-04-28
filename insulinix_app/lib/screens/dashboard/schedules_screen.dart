import 'package:flutter/material.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  void _addNewSchedule(BuildContext context) {
    // Later, this would open a screen to add a schedule
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add New Schedule feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedules')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Your Active Schedules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text('Morning Dose Reminder'),
                    subtitle: Text('Every day at 8:00 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text('Evening Check Reminder'),
                    subtitle: Text('Every day at 8:00 PM'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🛡️ Medical Risk Warning
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent, width: 2),
              ),
              child: const Text(
                '⚠️ WARNING:\n\n'
                'Changing schedules or dosing without medical supervision '
                'can be dangerous. Always consult with your healthcare provider '
                'before making changes to your insulin delivery or schedule settings. '
                'Changes are made at your own risk.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _addNewSchedule(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Add New Schedule',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
