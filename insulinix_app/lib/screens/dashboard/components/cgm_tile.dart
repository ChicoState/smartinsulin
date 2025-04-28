import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class CGMTile extends StatelessWidget {
  const CGMTile({super.key});

  // Simulated glucose values for last 48 hours
  List<FlSpot> _generateFakeGlucoseData() {
    List<FlSpot> data = [];
    double glucose = 100;
    Random random = Random();

    for (int i = 0; i < 48; i++) {
      glucose += random.nextDouble() * 10 - 5; // move up/down randomly
      glucose = glucose.clamp(70, 180); // stay within safe range
      data.add(FlSpot(i.toDouble(), glucose));
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final glucoseData = _generateFakeGlucoseData();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/monitor');
      },
      child: Container(
        width: 170,
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'Glucose (48h)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 48,
                  minY: 60,
                  maxY: 200,
                  titlesData: FlTitlesData(
                    show: false, // hide axis titles for clean look
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: glucoseData,
                      isCurved: true,
                      color: Colors.green[700],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.3),
                      ),
                      barWidth: 2,
                    ),
                  ],
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text('View >', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
