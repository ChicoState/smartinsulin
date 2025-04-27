import 'package:flutter/material.dart';
import 'components/device_tile.dart';
import 'components/last_bolus_tile.dart';
import 'components/cgm_tile.dart';
import 'components/drawer_menu.dart';
import 'components/chatbox_screen.dart';
import 'components/gemini_service.dart';

class MainDeviceScreen extends StatelessWidget {
  const MainDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text('Pod'),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.brightness_2), // Replace with toggle if needed
          SizedBox(width: 12),
        ],
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Pod'),
            Tab(text: 'Monitor'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Device Name', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const DeviceTile(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LastBolusTile(),
                CGMTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
