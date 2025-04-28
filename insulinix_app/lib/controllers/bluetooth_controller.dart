import 'dart:async';
import 'dart:convert'; // For utf8 encoding/decoding
import 'dart:io'; // For Platform checks (optional for specific logic)
import 'package:flutter/material.dart'; // For ChangeNotifier
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// --- UUID Placeholders ---
// !!! REPLACE THESE WITH YOUR DEVICE'S ACTUAL UUIDs !!!
const String YOUR_SERVICE_UUID = "0000xxxx-0000-1000-8000-00805f9b34fb"; // Example format
const String YOUR_WRITE_CHARACTERISTIC_UUID = "0000yyyy-0000-1000-8000-00805f9b34fb";
const String YOUR_NOTIFY_CHARACTERISTIC_UUID = "0000zzzz-0000-1000-8000-00805f9b34fb";
// --- End UUID Placeholders ---


// Simplified connection state enum for BLE
enum BleConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
  error,
}

class BluetoothController with ChangeNotifier {
  // --- Private Properties ---

  // Bluetooth adapter state stream subscription
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  // Scan results stream subscription
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  // Connection state stream subscription for the connected device
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  // Characteristic notification value stream subscription
  StreamSubscription<List<int>>? _notifyValueSubscription;

  // List to hold scan results
  List<ScanResult> _scanResults = [];

  // Characteristics for interaction (to be discovered)
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;


  // --- Public Properties (Readable State) ---

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  BluetoothAdapterState get adapterState => _adapterState;

  BleConnectionState _connectionState = BleConnectionState.disconnected;
  BleConnectionState get connectionState => _connectionState;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  // Provides an unmodifiable view of the scan results
  List<ScanResult> get scanResults => List.unmodifiable(_scanResults);

  BluetoothDevice? _connectedDevice;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  // StreamController to broadcast received data (as raw bytes)
  final StreamController<List<int>> _receivedDataController = StreamController<List<int>>.broadcast();
  Stream<List<int>> get receivedDataStream => _receivedDataController.stream;

  // --- Constructor ---
  BluetoothController() {
    _initialize();
  }

  // --- Initialization ---
  Future<void> _initialize() async {
    // Subscribe to adapter state changes
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      print("Bluetooth adapter state: $state");
      if (state == BluetoothAdapterState.off) {
        // Handle case where Bluetooth is turned off
        _handleDisconnection(error: false);
      }
      notifyListeners();
    });

    // Subscribe to scanning state changes
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
        _isScanning = state;
        if(!_isScanning && _connectionState == BleConnectionState.scanning){
            // If scanning stopped unexpectedly while we thought we were scanning
             _updateConnectionState(BleConnectionState.disconnected);
        }
        notifyListeners();
    });
  }

  // --- Public Methods ---

  /// Starts scanning for BLE devices.
  /// Ensure permissions (BLUETOOTH_SCAN, Location) are granted.
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (_isScanning || _connectionState != BleConnectionState.disconnected) {
      print("Cannot start scan: Already scanning or not disconnected.");
      return;
    }

    // Check if adapter is on
     if (_adapterState != BluetoothAdapterState.on) {
      print("Bluetooth adapter is off. Please turn it on.");
      // Optionally request user to turn it on (platform specific)
      // await FlutterBluePlus.turnOn(); // Example, might require user interaction
      return;
    }

    _updateConnectionState(BleConnectionState.scanning);
    _scanResults.clear(); // Clear previous results
    notifyListeners();

    try {
      // Subscribe to scan results before starting scan
      _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
          // Update results list (filter duplicates based on device ID)
          _scanResults = results;
          notifyListeners();
      }, onError: (e) {
          print("Scan results error: $e");
          stopScan(); // Stop scan on error
          _updateConnectionState(BleConnectionState.error);
      });

      // Start scanning
      await FlutterBluePlus.startScan(timeout: timeout);
       print("Scan started, timeout: $timeout");

      // Note: Scanning stops automatically on timeout or by calling stopScan()
       // The _isScanningSubscription will update the state when scanning actually stops.
       // If it stops normally after timeout, we go back to disconnected.
       if (_connectionState == BleConnectionState.scanning) {
            _updateConnectionState(BleConnectionState.disconnected);
       }


    } catch (e) {
      print("Error starting scan: $e");
       _updateConnectionState(BleConnectionState.error);
      stopScan(); // Ensure scan stops on error
    }
  }

  /// Stops the BLE device scan.
  Future<void> stopScan() async {
    await _scanResultsSubscription?.cancel();
    _scanResultsSubscription = null;
    await FlutterBluePlus.stopScan();
    // _isScanning state is updated by the _isScanningSubscription listener
     if (_connectionState == BleConnectionState.scanning) {
       _updateConnectionState(BleConnectionState.disconnected);
     }
     print("Scan stopped manually.");
  }

  /// Connects to the specified BLE device from scan results.
  Future<bool> connect(BluetoothDevice device) async {
    if (_isScanning) {
      await stopScan(); // Stop scanning before connecting
    }

    if (_connectionState == BleConnectionState.connecting ||
        _connectionState == BleConnectionState.connected) {
      print("Already connecting or connected.");
      return _connectionState == BleConnectionState.connected;
    }

    _updateConnectionState(BleConnectionState.connecting);
    _connectedDevice = device; // Keep track of the device we're connecting to

    try {
      // Listen to connection state changes *before* connecting
      _connectionStateSubscription = device.connectionState.listen(
        (BluetoothConnectionState state) async {
          print("Device ${device.remoteId} connection state: $state");
          if (state == BluetoothConnectionState.connected) {
            if (_connectionState != BleConnectionState.connected) {
               await _discoverServicesAndCharacteristics(device);
            }
          } else if (state == BluetoothConnectionState.disconnected) {
             _handleDisconnection(error: _connectionState != BleConnectionState.connected); // If we weren't fully connected, consider it an error/failure
          }
        },
        onError: (error) {
            print("Connection state stream error: $error");
            _handleDisconnection(error: true);
        }
      );

      // Connect to the device
      await device.connect(timeout: Duration(seconds: 15)); // Adjust timeout as needed
      print("Connect initiated for ${device.remoteId}");

      // Connection success is handled by the connectionState listener triggering service discovery

      // If connect call completes without throwing but state isn't connected (handled by listener),
      // it might indicate a timeout or silent failure before listener fired.
      // However, relying on the listener is generally better.

      return true; // Indicate connection attempt was initiated

    } catch (e) {
      print("Connection Error: $e");
      await _handleDisconnection(error: true);
      return false;
    }
  }


  /// Discovers services and required characteristics after connection.
  Future<void> _discoverServicesAndCharacteristics(BluetoothDevice device) async {
      print("Discovering services for ${device.remoteId}...");
      try {
          List<BluetoothService> services = await device.discoverServices();
          print("Services discovered: ${services.length}");

          _writeCharacteristic = null;
          _notifyCharacteristic = null;

          // Find the specific service and characteristics we need
          // !!! REPLACE UUID STRINGS BELOW !!!
          for (var service in services) {
              if (service.uuid == Guid(YOUR_SERVICE_UUID)) {
                  print("Found Service: ${service.uuid}");
                  for (var characteristic in service.characteristics) {
                      if (characteristic.uuid == Guid(YOUR_WRITE_CHARACTERISTIC_UUID)) {
                          _writeCharacteristic = characteristic;
                          print("Found Write Characteristic: ${characteristic.uuid}");
                      } else if (characteristic.uuid == Guid(YOUR_NOTIFY_CHARACTERISTIC_UUID)) {
                          _notifyCharacteristic = characteristic;
                          print("Found Notify Characteristic: ${characteristic.uuid}");
                      }
                  }
              }
          }

          if (_writeCharacteristic != null && _notifyCharacteristic != null) {
              print("Required characteristics found.");
              await _subscribeToNotifications(); // Subscribe after finding characteristic
              _updateConnectionState(BleConnectionState.connected); // Mark as fully connected
          } else {
              print("Error: Required characteristics not found.");
              await _handleDisconnection(error: true);
          }

      } catch (e) {
          print("Service discovery error: $e");
          await _handleDisconnection(error: true);
      }
  }


  /// Subscribes to notifications from the notify characteristic.
  Future<void> _subscribeToNotifications() async {
      if (_notifyCharacteristic == null || !connectedDevice!.isConnected) {
        print("Cannot subscribe: Characteristic not found or not connected.");
        return;
      }

      try {
          await _notifyValueSubscription?.cancel(); // Cancel previous subscription if any
          await _notifyCharacteristic!.setNotifyValue(true);

          _notifyValueSubscription = _notifyCharacteristic!.lastValueStream.listen(
              (value) {
                  // print("Received notification: $value -> ${utf8.decode(value, allowMalformed: true)}"); // Example decoding
                  _receivedDataController.add(value); // Broadcast raw bytes
              },
              onError: (error) {
                  print("Notification stream error: $error");
                  _handleDisconnection(error: true); // Assume connection issue
              }
          );
          print("Subscribed to notifications for ${_notifyCharacteristic!.uuid}");

      } catch (e) {
          print("Error subscribing to notifications: $e");
           if (connectedDevice!.isConnected){
                await _handleDisconnection(error: true);
           }
      }
  }

  /// Sends data (as bytes) to the write characteristic.
  Future<bool> sendMessage(List<int> data) async {
    if (_connectionState != BleConnectionState.connected || _writeCharacteristic == null) {
      print("Cannot send message: Not connected or write characteristic not found.");
      return false;
    }

    try {
      await _writeCharacteristic!.write(
        data,
        withoutResponse: false, // Change to true if your device/characteristic uses WriteWithoutResponse
        allowLongWrite: true, // Use long write if data might exceed MTU
      );
      print("Message sent: $data -> ${utf8.decode(data, allowMalformed: true)}"); // Example decoding
      return true;
    } catch (e) {
      print("Send Error: $e");
      // Optionally check connection state again here before assuming disconnection
      if (connectedDevice?.isConnected ?? false) {
          // Might be a write-specific error, not necessarily disconnected
           print("Write failed but still connected?");
      } else {
          _handleDisconnection(error: true);
      }
      return false;
    }
  }

   /// Sends data (as string, UTF-8 encoded) to the write characteristic.
  Future<bool> sendMessageString(String message) async {
       // Encode the string to Uint8List (UTF-8 is common)
      List<int> data = utf8.encode(message);
      return await sendMessage(data);
  }

  /// Reads the value of a characteristic (example, adapt as needed).
  Future<List<int>?> readSomeCharacteristic(Guid serviceUuid, Guid charUuid) async {
       if (_connectionState != BleConnectionState.connected) {
         print("Cannot read: Not connected.");
         return null;
       }
       try {
           BluetoothCharacteristic? targetChar;
           List<BluetoothService> services = await _connectedDevice!.discoverServices(); // Re-discover or use cached? FBP caches.
            for (var service in services) {
                if (service.uuid == serviceUuid) {
                     for (var characteristic in service.characteristics) {
                         if (characteristic.uuid == charUuid) {
                              targetChar = characteristic;
                              break;
                         }
                     }
                }
                if (targetChar != null) break;
            }

           if (targetChar != null && targetChar.properties.read) {
               List<int> value = await targetChar.read();
               print("Read value from $charUuid: $value");
               return value;
           } else {
                print("Characteristic $charUuid not found or not readable.");
                return null;
           }
       } catch (e) {
           print("Read error: $e");
           return null;
       }
  }


  /// Disconnects from the currently connected device.
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect(); // Request disconnection
    }
    // State update is handled by the connectionState listener calling _handleDisconnection
    print("Disconnect requested.");
  }

  // --- Private Helper Methods ---

  /// Centralized method to clean up connection resources and update state.
  Future<void> _handleDisconnection({bool error = false}) async {
     if (_connectionState == BleConnectionState.disconnected && !error) {
       // Already disconnected and not due to an error, nothing to do
       return;
     }
    print("Cleaning up connection resources... Error: $error");

    await _notifyValueSubscription?.cancel();
    _notifyValueSubscription = null;
    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;

    // No explicit connection object to dispose like in flutter_bluetooth_serial
    // FBP handles the underlying connection closure via device.disconnect()

    _connectedDevice = null;
    _writeCharacteristic = null;
    _notifyCharacteristic = null;

     // Update state *after* cleanup
    _updateConnectionState(error ? BleConnectionState.error : BleConnectionState.disconnected);
  }


  /// Updates the connection state and notifies listeners.
  void _updateConnectionState(BleConnectionState state) {
    // Prevent transitioning away from error state unless explicitly disconnected
    if (_connectionState == BleConnectionState.error && state != BleConnectionState.disconnected){
        return;
    }
    _connectionState = state;
    notifyListeners();
  }

  // --- Cleanup ---

  @override
  void dispose() {
    print("Disposing BluetoothController...");
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
    _handleDisconnection(); // Ensure resources are cleaned up
    _receivedDataController.close();
    super.dispose();
  }
}