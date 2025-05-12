import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// new
class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  String? linkedPatientId;
  double? latestGlucose;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchLinkedPatientId();
  }

  Future<void> fetchLinkedPatientId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    linkedPatientId = doc.data()?['linkedPatientId'];

    if (linkedPatientId != null) {
      fetchGlucoseData(linkedPatientId!);
    } else {
      setState(() {
        status = "No patient linked.";
      });
    }
  }

  Future<void> fetchGlucoseData(String patientId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(patientId)
        .collection('glucose_readings')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final value = snapshot.docs.first.data()['value'];
      setState(() {
        latestGlucose = value.toDouble();
        status = _determineStatus(latestGlucose!);
      });
    } else {
      setState(() {
        status = "No glucose data available.";
      });
    }
  }

  String _determineStatus(double value) {
    if (value < 70) return "❗ Low";
    if (value > 180) return "⚠️ High";
    return "✅ Balanced";
  }

  void _addPatientDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Link Patient ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Patient UID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && controller.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({'linkedPatientId': controller.text.trim()});
                Navigator.pop(context);
                fetchLinkedPatientId(); // reload
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
            ),
            child: const Text('Link', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitor Patient')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Patient Glucose Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                latestGlucose != null ? 'Latest: $latestGlucose mg/dL' : 'No data',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                status,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: status.contains("Low")
                      ? Colors.red
                      : status.contains("High")
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addPatientDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Add Patient to Monitor', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                child: const Text(
                  '⚠️ This screen is for monitoring only.\nYou cannot modify the patient’s account or health data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
