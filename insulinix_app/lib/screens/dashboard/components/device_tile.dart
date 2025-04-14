import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('123', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('mg/dL', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
