import 'package:flutter/material.dart';

class SetupIntroScreen extends StatelessWidget {
  const SetupIntroScreen({super.key});

  void _goToNext(BuildContext context) {
    Navigator.pushNamed(context, '/setup-bolus');
  }

  @override
  Widget build(BuildContext context) {
    final String name = "Alex"; // Replace this with dynamic data

    return Scaffold(
      appBar: AppBar(title: const Text("SETUP")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            const Text("<GREETING MESSAGE>", style: TextStyle(color: Colors.blue)),
            const Text("<SETUP MESSAGE>"),
            const SizedBox(height: 48),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 40),
              onPressed: () => _goToNext(context),
            ),
            const SizedBox(height: 24),
            const Text("<HEALTH & SAFETY WARNING MESSAGE>", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
