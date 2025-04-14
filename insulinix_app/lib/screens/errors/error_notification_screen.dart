import 'package:flutter/material.dart';

class ErrorNotificationScreen extends StatelessWidget {
  const ErrorNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: const [
            Icon(Icons.error, color: Colors.black),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ERROR NOTIFICATION', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Error\nDetails'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
