import 'package:flutter/material.dart';

class PodStatusScreen extends StatelessWidget {
  const PodStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pod Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            ListTile(
              leading: Icon(Icons.battery_charging_full),
              title: Text('Battery Level'),
              subtitle: Text('85%'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Insulin Delivery'),
              subtitle: Text('Ongoing'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.timelapse),
              title: Text('Pod Life Remaining'),
              subtitle: Text('24 hours'),
            ),
          ],
        ),
      ),
    );
  }
}
