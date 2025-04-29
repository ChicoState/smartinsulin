import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Import flutter_blue_plus for ScanResult
import '../../controllers/bluetooth_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  Future<bool> _checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses;
    // Define required permissions (Adjust based on target Android versions)
    List<Permission> permissionsToRequest = [];
    if (Platform.isAndroid) {
      // Check Android version if necessary for older location requirements
      // For simplicity, assume targeting API 31+ primarily
      permissionsToRequest.addAll([
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        // Add Permission.locationWhenInUse IF needed for older versions or location derivation
      ]);
    } else {
      // iOS
      permissionsToRequest.add(Permission.bluetooth);
    }

    statuses = await permissionsToRequest.request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print("Bluetooth permissions were not granted.");
      // Optional: Show a dialog explaining why permissions are needed
      // You might want to check statuses[Permission.bluetoothScan]?.isPermanentlyDenied etc.
      // and guide the user to settings using appSettings.openAppSettings()
    }
    return allGranted;
  }

  void _showDeviceScanDialog(BuildContext context) async {
    final bluetoothController = Provider.of<BluetoothController>(
      context,
      listen: false,
    );

    // --- CHECK PERMISSIONS FIRST ---
    bool permissionsGranted =
        await _checkAndRequestPermissions(); // Call the local method
    if (!permissionsGranted && mounted) {
      // Check mounted after async gap
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bluetooth permissions are required to scan.'),
        ),
      );
      return;
    }
    // --- END PERMISSION CHECK ---

    if (!mounted) return; // Check mounted again before showing dialog

    bluetoothController.startScan(); // Proceed only if permissions granted

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return DeviceScanDialog(bluetoothController: bluetoothController);
      },
    ).then((_) {
      if (bluetoothController.isScanning) {
        bluetoothController.stopScan();
      }
    });
  }

  //  void _showDeviceScanDialog(BuildContext context) {
  //   final bluetoothController =
  //       Provider.of<BluetoothController>(context, listen: false);

  //   // Start scanning immediately when the dialog opens
  //   bluetoothController.startScan();

  //   showDialog(
  //     context: context,
  //     // Prevent closing dialog by tapping outside while scanning/connecting
  //     barrierDismissible: false,
  //     builder: (BuildContext dialogContext) {
  //       // Use a StatefulWidget for the dialog content
  //       // to manage its own state, like listening to the controller.
  //       return DeviceScanDialog(bluetoothController: bluetoothController);
  //     },
  //   ).then((_) {
  //     // Optional: Ensure scan stops if dialog is closed prematurely
  //     // although controller might handle this with timeouts.
  //     if (bluetoothController.isScanning) {
  //        bluetoothController.stopScan();
  //     }
  //   });
  // }

  void _toggleDarkMode() {
    setState(() {
      darkModeEnabled = !darkModeEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          darkModeEnabled ? 'Dark mode enabled' : 'Dark mode disabled',
        ),
      ),
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

  void _signOut() {
    // Sign out logic would be added later
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothController = Provider.of<BluetoothController>(context);

    String tileTitle = 'Connect Bluetooth';
    IconData tileIcon = Icons.bluetooth_disabled; // Default icon
    VoidCallback? onTapAction;

    switch (bluetoothController.connectionState) {
      case BleConnectionState.disconnected:
      case BleConnectionState.error: // Allow retry on error
        tileTitle = 'Connect Bluetooth';
        tileIcon = Icons.bluetooth;
        onTapAction = () => _showDeviceScanDialog(context);
        break;
      case BleConnectionState.scanning:
        tileTitle = 'Scanning...';
        tileIcon = Icons.bluetooth_searching;
        onTapAction =
            () => bluetoothController.stopScan(); // Allow stopping scan
        break;
      case BleConnectionState.connecting:
        tileTitle = 'Connecting...';
        tileIcon = Icons.bluetooth_searching;
        onTapAction = null; // Disable tap while connecting
        break;
      case BleConnectionState.connected:
        // Optionally show device name
        final deviceName =
            bluetoothController.connectedDevice?.platformName ??
            'Unknown Device';
        tileTitle = 'Disconnect $deviceName';
        tileIcon = Icons.bluetooth_connected;
        onTapAction = () {
          bluetoothController
              .disconnect()
              .then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bluetooth disconnected.')),
                );
              })
              .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Disconnection error: $error')),
                );
              });
        };
        break;
    }

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
            leading: Icon(tileIcon),
            title: Text(tileTitle),
            subtitle:
                bluetoothController.connectionState == BleConnectionState.error
                    ? const Text(
                      'Connection failed. Tap to retry.',
                      style: TextStyle(color: Colors.red),
                    )
                    : null,
            onTap: onTapAction, // Use the determined action
            enabled: onTapAction != null, // Disable tap if action is null
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class DeviceScanDialog extends StatefulWidget {
  final BluetoothController bluetoothController;

  const DeviceScanDialog({Key? key, required this.bluetoothController})
    : super(key: key);

  @override
  _DeviceScanDialogState createState() => _DeviceScanDialogState();
}

class _DeviceScanDialogState extends State<DeviceScanDialog> {
  // Listen to controller changes within the dialog
  // No need for explicit listener setup if using Consumer or Selector

  Future<void> _connectToDevice(BluetoothDevice device) async {
    // Show feedback that connection is starting
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connecting to ${device.platformName}...")),
    );
    Navigator.of(context).pop(); // Close the dialog

    bool success = await widget.bluetoothController.connect(device);

    if (mounted) {
      // Check if widget is still in the tree
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected to ${device.platformName}!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to ${device.platformName}.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen to changes in BluetoothController
    return Consumer<BluetoothController>(
      builder: (context, controller, child) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Ensures text only shrinks, doesn't grow
                  alignment: Alignment.centerLeft, // Keep text aligned left
                  child: const Text('Available Devices'),
                ),
              ),
              if (controller.isScanning)
                const Padding(
                   padding: EdgeInsets.only(left: 8.0), // Add some left padding
                   child: SizedBox(
                       width: 20,
                       height: 20,
                       child: CircularProgressIndicator(strokeWidth: 2)),
                 ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Adjust height as needed
            child:
                (controller.scanResults.isEmpty && !controller.isScanning)
                    ? const Center(
                      child: Text(
                        'No devices found. Ensure Bluetooth is on and device is discoverable.',
                      ),
                    )
                    : ListView.builder(
                      itemCount: controller.scanResults.length,
                      itemBuilder: (context, index) {
                        ScanResult result = controller.scanResults[index];
                        String deviceName =
                            result.device.platformName.isNotEmpty
                                ? result.device.platformName
                                : 'Unknown Device';
                        String deviceId = result.device.remoteId.toString();

                        return ListTile(
                          title: Text(deviceName),
                          subtitle: Text(deviceId),
                          trailing: Text(
                            '${result.rssi} dBm',
                          ), // Signal strength
                          onTap: () => _connectToDevice(result.device),
                        );
                      },
                    ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                controller.stopScan(); // Stop scan if running
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
