import 'dart:async';
import 'package:flutter/material.dart';

// --- Battery Simulator Class (can be extracted to battery_simulator.dart) ---
class BatterySimulator {
  double _batteryLevel = 100.0; // percent
  bool isCharging = false;

  void simulateDrain({bool deliveringInsulin = false}) {
    if (isCharging) {
      _batteryLevel = (_batteryLevel + 1).clamp(0.0, 100.0);
    } else {
      double drainRate = deliveringInsulin ? 0.5 : 0.1;
      _batteryLevel = (_batteryLevel - drainRate).clamp(0.0, 100.0);
    }
  }

  void toggleCharging() {
    isCharging = !isCharging;
  }

  double get batteryLevel => _batteryLevel;
  bool get charging => isCharging;
}

// --- Main PodStatusScreen with Battery Simulation ---
class PodStatusScreen extends StatefulWidget {
  const PodStatusScreen({super.key});

  @override
  State<PodStatusScreen> createState() => _PodStatusScreenState();
}

class _PodStatusScreenState extends State<PodStatusScreen> {
  final BatterySimulator _batterySimulator = BatterySimulator();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _batterySimulator.simulateDrain(deliveringInsulin: true); // Simulating active delivery
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final batteryLevel = _batterySimulator.batteryLevel.toStringAsFixed(1);
    final isCharging = _batterySimulator.charging;

    return Scaffold(
      appBar: AppBar(title: const Text('Pod Status'), centerTitle: true,),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                isCharging ? Icons.battery_charging_full : Icons.battery_std,
                color: _batterySimulator.batteryLevel > 20 ? Colors.green : Colors.red,
              ),
              title: const Text('Battery Level'),
              subtitle: Text('$batteryLevel%'),
              trailing: IconButton(
                icon: Icon(
                  isCharging ? Icons.power_off : Icons.power,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _batterySimulator.toggleCharging();
                  });
                },
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Insulin Delivery'),
              subtitle: Text('Ongoing'),
            ),
            const Divider(),
            const ListTile(
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

