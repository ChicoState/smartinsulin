import 'package:flutter/material.dart';
import 'components/device_tile.dart';
import 'components/last_bolus_tile.dart';
import 'components/cgm_tile.dart';
import 'components/drawer_menu.dart';
import 'components/chatbox_screen.dart';

class MainDeviceScreen extends StatelessWidget {
  const MainDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const DrawerMenu(),
        appBar: AppBar(
          title: const Text('Smart Pod Dashboard'),
          actions: const [
            Icon(Icons.notifications_none),
            SizedBox(width: 12),
            Icon(Icons.brightness_2), // Later: dark/light mode toggle
            SizedBox(width: 12),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pod Status'),
              Tab(text: 'Monitor'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PodTabContent(),
            MonitorTabContent(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          tooltip: 'Chat Assistant',
          child: const Icon(Icons.chat_bubble_outline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatBoxScreen()),
            );
          },
        ),
      ),
    );
  }
}

// 🔵 POD STATUS TAB
class PodTabContent extends StatelessWidget {
  const PodTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Device Status',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const DeviceTile(), // Shows pod battery, connection, etc
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LastBolusTile(), // Shows last insulin dose
                CGMTile(),       // Shows mini glucose graph (48h trend)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🟢 MONITOR TAB
class MonitorTabContent extends StatelessWidget {
  const MonitorTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Continuous Glucose Monitoring',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '📈 Full CGM Graph\n(Coming Soon)',
                style: TextStyle(fontSize: 18, color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Monitoring your glucose readings every 5 minutes.\nStay within your safe target range.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
