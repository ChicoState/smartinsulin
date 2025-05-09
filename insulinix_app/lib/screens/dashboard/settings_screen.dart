import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pdf_exporter.dart'; // ✅ Make sure you import your pdf_exporter.dart

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

    // Restart theme across app (optional: move to provider later)
    final brightness = darkModeEnabled ? Brightness.dark : Brightness.light;
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: brightness,
      ));
    };

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

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _exportPDF() async {
    await PDFExporter.exportData(
      glucoseData: [
        {'time': '8:00 AM', 'value': 120},
        {'time': '12:00 PM', 'value': 140},
      ],
      notesData: [
        {'date': 'Mar 10, 2024', 'note': 'High after breakfast.'},
        {'date': 'Mar 11, 2024', 'note': 'Low before dinner.'},
      ],
      insulinData: [
        {'time': '8:00 AM', 'units': 5},
        {'time': '7:00 PM', 'units': 4},
      ],
    );
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
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Export Report (PDF)'),
            onTap: _exportPDF,
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
