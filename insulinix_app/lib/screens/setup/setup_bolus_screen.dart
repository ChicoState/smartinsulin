import 'package:flutter/material.dart';

class SetupBolusScreen extends StatefulWidget {
  const SetupBolusScreen({super.key});

  @override
  State<SetupBolusScreen> createState() => _SetupBolusScreenState();
}

class _SetupBolusScreenState extends State<SetupBolusScreen> {
  final _bolusRateController = TextEditingController();

  void _onNext() {
    Navigator.pushNamed(context, '/all-done');
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _bolusRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SETUP: Bolus"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'SET MAXIMUM BOLUS RATE',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text('(1 to 400 mg/dL)', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _bolusRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: 'mg/dL',
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onCancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('NEXT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
