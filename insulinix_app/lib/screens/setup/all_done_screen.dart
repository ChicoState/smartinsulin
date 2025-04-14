import 'package:flutter/material.dart';

class AllDoneScreen extends StatelessWidget {
  const AllDoneScreen({super.key});

  void _goToDeviceScreen(BuildContext context) {
   Navigator.pushReplacementNamed(context, '/dashboard');

  }

  @override
  Widget build(BuildContext context) {
    final String userName = "Elizabeth"; // Replace with dynamic name if available

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ALL SET!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Welcome", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 24),
              const Icon(Icons.check_circle, size: 100, color: Colors.black),
              const SizedBox(height: 24),
              const Text(
                "Your device has been linked to your account!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _goToDeviceScreen(context), // ✅ FIXED THIS LINE
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("OK!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
