import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'components/glucose_data.dart';
import 'user_log_service.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late List<Map<String, dynamic>> cgmData;
  bool showGraph = false;
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cgmData = GlucoseDataService.generateCGMData();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = doc.data()?['name'] ?? 'User';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double latestGlucose = cgmData.last['glucose'];
    final double insulinDose = GlucoseDataService.calculateInsulinDose(
      currentGlucose: latestGlucose,
      targetGlucose: 100,
      correctionFactor: 50,
      carbsEaten: 45,
      carbRatio: 10,
    );

    final String formattedDate = DateFormat('MM/dd/yy').format(DateTime.now());

    // ✅ Update logs
    UserLogService.glucoseData.clear();
    UserLogService.glucoseData.addAll(cgmData.map((e) {
      return {
        'time': e['timestamp'] != null
            ? DateFormat('h:mm a').format(e['timestamp'])
            : 'unknown',
        'value': e['glucose'],
      };
    }));

    UserLogService.insulinData.add({
      'time': DateFormat('h:mm a').format(DateTime.now()),
      'units': insulinDose.toStringAsFixed(1),
    });

    return Scaffold(
      appBar: AppBar(
        
        title: Text("$userName's device"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Glucose display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Text(
                    '${latestGlucose.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Text('mg/dL', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {}, // Hook up PDF export
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Export to PDF', style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        const Text('Last Bolus', style: TextStyle(fontSize: 14)),
                        Text(formattedDate, style: const TextStyle(fontSize: 12)),
                        Text(
                          '${insulinDose.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('Units'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        const Text('CGM', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() => showGraph = !showGraph),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          ),
                          child: const Text('View', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (showGraph) ...[
              const Text(
                '24-Hour Glucose Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(height: 250, child: _buildCGMGraph()),
            ],

            const SizedBox(height: 24),

            ExpansionTile(
              title: const Text('What is CGM?'),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'CGM stands for Continuous Glucose Monitoring. It tracks your glucose levels 24/7 using a small sensor.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('What is a Bolus?'),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'A bolus is a dose of insulin taken to manage a rise in blood glucose, typically after meals.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('What does mg/dL mean?'),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'mg/dL stands for milligrams per deciliter. It is the standard unit used to measure glucose levels in your blood.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCGMGraph() {
    final spots = <FlSpot>[];
    final labels = <double, String>{};

    for (int i = 0; i < cgmData.length; i++) {
      final glucose = cgmData[i]['glucose'];
      final timestamp = cgmData[i]['timestamp'];

      spots.add(FlSpot(i.toDouble(), glucose));

      if (timestamp != null && timestamp is DateTime && i % 4 == 0) {
        final label = DateFormat('ha').format(timestamp);
        labels[i.toDouble()] = label;
      }
    }

    return LineChart(
      LineChartData(
        minY: 60,
        maxY: 220,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 4,
              getTitlesWidget: (value, _) {
                return Text(
                  labels[value] ?? '',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, _) {
                return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
