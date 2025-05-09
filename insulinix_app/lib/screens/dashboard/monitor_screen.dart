import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'components/glucose_data.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late List<Map<String, dynamic>> cgmData;
  final TextEditingController _carbsController = TextEditingController(text: '45');
  final TextEditingController _targetGlucoseController = TextEditingController(text: '100');

  @override
  void initState() {
    super.initState();
    cgmData = GlucoseDataService.generateCGMData();
  }

  @override
  void dispose() {
    _carbsController.dispose();
    _targetGlucoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double latestGlucose = cgmData.last['glucose'];

    final double carbs = double.tryParse(_carbsController.text) ?? 0;
    final double targetGlucose = double.tryParse(_targetGlucoseController.text) ?? 100;

    final insulinDose = GlucoseDataService.calculateInsulinDose(
      currentGlucose: latestGlucose,
      targetGlucose: targetGlucose,
      correctionFactor: 50,
      carbsEaten: carbs,
      carbRatio: 10,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Glucose Monitor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Current Glucose',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${latestGlucose.toStringAsFixed(0)} mg/dL',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Inputs
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Carbs Eaten (g)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _targetGlucoseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target Glucose',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple),
              ),
              child: Column(
                children: [
                  const Text(
                    'Recommended Insulin Dose',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${insulinDose.toStringAsFixed(1)} units',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Glucose Trends (48h)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: _buildCGMGraph(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCGMGraph() {
    final spots = cgmData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = entry.value['glucose'];
      return FlSpot(index, value);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 60,
        maxY: 220,
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
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
