import 'package:flutter/material.dart';

class ErrorOverlayScreen extends StatelessWidget {
  const ErrorOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'ERROR MESSAGE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.cancel, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
