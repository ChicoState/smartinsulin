import 'package:flutter/material.dart';
import 'components/cgm_tile.dart'; // Import CGMTile

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Glucose Monitoring',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const CGMTile(), // ✅ Added CGM Tile inside Monitor tab
          const SizedBox(height: 30),
          const Text(
            'Your CGM is monitoring your blood glucose trends every 5 minutes.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
