import 'package:flutter/material.dart';

class CGMTile extends StatelessWidget {
  const CGMTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/monitor');
      },
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart),
            SizedBox(height: 8),
            Text('CGM Chart', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('View >'),
          ],
        ),
      ),
    );
  }
}
