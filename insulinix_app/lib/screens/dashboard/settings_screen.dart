import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pdf_exporter.dart';
import 'user_log_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBluetoothConnected = false;
  bool notificationsEnabled = true;

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

  void _toggleNotifications() {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          notificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
      ),
    );
  }

  void _exportPDF() async {
    await PDFExporter.exportData(
      glucoseData: UserLogService.glucoseData,
      notesData: UserLogService.notesData,
      insulinData: UserLogService.insulinData,
      mealData: UserLogService.mealData,
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: isBluetoothConnected ? _disconnectBluetooth : _connectBluetooth,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              isBluetoothConnected ? Icons.bluetooth_disabled : Icons.bluetooth,
              color: Colors.white,
            ),
            label: Text(
              isBluetoothConnected ? 'Disconnect Bluetooth' : 'Connect Bluetooth',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'App Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            value: notificationsEnabled,
            onChanged: (_) => _toggleNotifications(),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _exportPDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text(
              'Export Report (PDF)',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
