import 'package:flutter/material.dart';

class LastBolusTile extends StatelessWidget {
  const LastBolusTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Last Bolus', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('04/06/25'),
          Text('2.0 Units'),
        ],
      ),
    );
  }
}
