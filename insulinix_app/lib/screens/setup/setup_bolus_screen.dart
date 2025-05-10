import 'package:flutter/material.dart';

class SetupBolusScreen extends StatefulWidget {
  const SetupBolusScreen({super.key});

  @override
  State<SetupBolusScreen> createState() => _SetupBolusScreenState();
}

class _SetupBolusScreenState extends State<SetupBolusScreen> {
  final _bolusRateController = TextEditingController();
  bool showBolusInfo = false; // 👈 for dropdown visibility

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
                color: Colors.green,
                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 20),

            // 🔽 Bolus Info Expandable Section
            GestureDetector(
              onTap: () {
                setState(() {
                  showBolusInfo = !showBolusInfo;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showBolusInfo ? 'Hide "What is Bolus?"' : 'Show "What is Bolus?"',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    showBolusInfo ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            if (showBolusInfo)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade600),
                  ),
                  child: const Text(
                    '💉 Bolus insulin is a fast-acting insulin used to control blood sugar spikes, '
                    'typically taken before meals. Setting a safe bolus rate ensures you do not overdose. '
                    'Always consult your healthcare provider before adjusting bolus settings.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ⚠️ Safety Warning Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent, width: 2),
              ),
              child: const Text(
                '⚠️ WARNING:\n\n'
                'Incorrect bolus settings can lead to dangerous blood sugar levels. '
                'Only set the maximum bolus rate if you have been advised by your healthcare provider.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onCancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('CANCEL', style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('NEXT', style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
