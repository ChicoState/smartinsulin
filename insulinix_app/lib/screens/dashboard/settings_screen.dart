import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBluetoothConnected = false;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  void _connectBluetooth() async {
    // Here you can later integrate real Bluetooth connection logic
    setState(() {
      isBluetoothConnected = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bluetooth connected successfully!')),
    );
  }

  void _disconnectBluetooth() {
    setState(() {
      isBluetoothConnected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bluetooth disconnected.')),
    );
  }

  void _toggleDarkMode() {
    setState(() {
      darkModeEnabled = !darkModeEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(darkModeEnabled ? 'Dark mode enabled' : 'Dark mode disabled'),
      ),
    );
  }

  void _toggleNotifications() {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled'),
      ),
    );
  }

  void _signOut() {
    // Sign out logic would be added later
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Device Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(isBluetoothConnected ? 'Disconnect Bluetooth' : 'Connect Bluetooth'),
            onTap: () {
              if (isBluetoothConnected) {
                _disconnectBluetooth();
              } else {
                _connectBluetooth();
              }
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'App Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            value: notificationsEnabled,
            onChanged: (_) => _toggleNotifications(),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: darkModeEnabled,
            onChanged: (_) => _toggleDarkMode(),
          ),

          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _signOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              'Sign Out',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
