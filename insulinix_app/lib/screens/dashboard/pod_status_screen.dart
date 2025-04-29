import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/bluetooth_controller.dart';

// --- Main PodStatusScreen with Battery Simulation ---
class PodStatusScreen extends StatefulWidget {
  const PodStatusScreen({super.key});

  @override
  State<PodStatusScreen> createState() => _PodStatusScreenState();
}

class _PodStatusScreenState extends State<PodStatusScreen> {
  
  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _dataSubscription;
  BluetoothController? _bluetoothController;

  // State variables to hold parsed data
  String? _batteryStatus; // e.g., "High", "Mid", "Low", or percentage
  String? _dosesRemainingStatus; // e.g., "High", "Mid", "Low"

  BleConnectionState? _previousConnectionState;


  @override
  void initState() {
    super.initState();
    // Get controller instance here or in didChangeDependencies if needed before build
    // Ensure listen: false if only accessing methods/streams initially
     _bluetoothController = Provider.of<BluetoothController>(context, listen: false);
     _previousConnectionState = _bluetoothController?.connectionState;

     // Initial setup: Subscribe if already connected
     if (_previousConnectionState == BleConnectionState.connected) {
         _batteryStatus = "Loading...";
         _dosesRemainingStatus = "Loading...";
         _subscribeToData();
     } else {
        _clearStatus();
     }
  }




   void _subscribeToData() {
    if (_dataSubscription != null) return; // Already subscribed

    _dataSubscription = _bluetoothController?.receivedDataStream.listen((data) {
      // ---=== Placeholder for Data Parsing ===---
      String parsedBattery = "Unknown";
      String parsedDoses = "Unknown";
      try {
        // Example: Assume first byte is battery (0-100), second is doses (0-255)
        if (data.isNotEmpty) {
            int batteryPercent = data[0];
             if(batteryPercent > 70) parsedBattery = "High";
             else if (batteryPercent > 30) parsedBattery = "Mid";
             else parsedBattery = "Low";
        }
         if (data.length > 1) {
             int dosesValue = data[1];
             if(dosesValue > 150) parsedDoses = "High";
             else if (dosesValue > 50) parsedDoses = "Mid";
             else parsedDoses = "Low";
         }
        // --- Replace above example with your actual parsing ---
      } catch (e) {
        print("Error parsing BLE data: $e");
        parsedBattery = "Parse Error";
        parsedDoses = "Parse Error";
      }
      // ---=== End Placeholder ===---
      if (mounted) { // Check if widget is still in the tree before calling setState
        setState(() {
          _batteryStatus = parsedBattery;
          _dosesRemainingStatus = parsedDoses;
        });
      }
    }, onError: (error) {
      print("Data stream error: $error");
       if (mounted) {
          setState(() {
              _batteryStatus = "Stream Error";
              _dosesRemainingStatus = "Stream Error";
          });
       }
    });
    print("Subscribed to data stream.");
  }

  void _unsubscribeFromData() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    print("Unsubscribed from data stream.");
  }

  void _clearStatus() {
    // Use setState only if potentially called outside of build context
    if (mounted) {
        setState(() {
           _batteryStatus = null;
           _dosesRemainingStatus = null;
        });
    } else {
         _batteryStatus = null;
         _dosesRemainingStatus = null;
    }

  }

  @override
  void dispose() {
    _unsubscribeFromData(); // Ensure data subscription is cancelled
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BluetoothController, BleConnectionState>(
      selector: (_, controller) => controller.connectionState,
      builder: (context, connectionState, child) {
        // Check if state changed to manage data subscription
        if (connectionState != _previousConnectionState) {
           print("Connection state changed from $_previousConnectionState to $connectionState");
           if (connectionState == BleConnectionState.connected) {
             // Just connected
             _clearStatus(); // Clear old data immediately
              // Use WidgetsBinding to schedule state update after build
             WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                    setState(() {
                       _batteryStatus = "Loading...";
                       _dosesRemainingStatus = "Loading...";
                    });
                 }
             });
             _subscribeToData();
           } else {
             // Just disconnected (or entered other state like error/scanning)
             _unsubscribeFromData();
             _clearStatus();
           }
           _previousConnectionState = connectionState; // Update previous state
        }

        final bool isConnected = connectionState == BleConnectionState.connected;

        return Scaffold(
          appBar: AppBar(title: const Text('Pod Status')),
          body: Stack(
            children: [
              // Main content (status list)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isConnected ? Icons.battery_std : Icons.battery_unknown,
                        color: isConnected ? Colors.green : Colors.grey,
                      ),
                      title: const Text('Battery Status'),
                      subtitle: Text(_batteryStatus ?? '---'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.access_time, color: Colors.grey),
                      title: Text('Insulin Delivery'),
                      subtitle: Text('---'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        isConnected ? Icons.medication_liquid : Icons.help_outline,
                        color: isConnected ? Colors.blue : Colors.grey,
                      ),
                      title: const Text('Doses Remaining'),
                      subtitle: Text(_dosesRemainingStatus ?? '---'),
                    ),
                    const Divider(),
                  ],
                ),
              ),

              // Overlay when not connected
              if (!isConnected)
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.withOpacity(0.8),
                    child: const Center(
                      child: Text(
                        'No device connected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

