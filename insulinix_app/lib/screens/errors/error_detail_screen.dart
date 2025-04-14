import 'package:flutter/material.dart';

class ErrorDetailScreen extends StatelessWidget {
  const ErrorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ERROR MESSAGE'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Error Code', 'Snackbar supporting text'),
            _buildSection('Type', 'Snackbar supporting text'),
            _buildSection('Details', 'Snackbar supporting text'),
            _buildSection('Solution', 'Snackbar supporting text'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Add your report logic here
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Report'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(content, style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
