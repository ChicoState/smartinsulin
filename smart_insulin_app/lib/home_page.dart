import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data to simulate readings and statuses.
  double currentGlucose = 120; // Example: mg/dL
  double insulinDose = 5; // Example: units
  String trend = "up"; // Could be "up", "down", or "stable"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartInsulin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to Settings page
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'SmartInsulin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                // TODO: Navigate to Dashboard page
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Data Logging'),
              onTap: () {
                // TODO: Navigate to History/Data Logging page
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: () {
                // TODO: Navigate to Account page
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Legal & Privacy'),
              onTap: () {
                // TODO: Navigate to Legal & Privacy page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // TODO: Navigate to Settings page
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Example banner or info box for real-time alerts or updates
          Container(
            width: double.infinity,
            color: Colors.redAccent,
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Alert: Your blood sugar is trending $trend!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Connection status for CGM and Insulin Pump.
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.bluetooth, color: Colors.green),
                      title: Text('Device Connection'),
                      subtitle: Text('CGM & Insulin Pump connected'),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dashboard grid showing key information.
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        DashboardCard(
                          title: 'Glucose Level',
                          value: '$currentGlucose mg/dL',
                          icon: Icons.opacity,
                        ),
                        DashboardCard(
                          title: 'Insulin Dose',
                          value: '$insulinDose units',
                          icon: Icons.medical_services,
                        ),
                        DashboardCard(
                          title: 'Alerts',
                          value: 'No Alerts',
                          icon: Icons.notifications,
                        ),
                        DashboardCard(
                          title: 'History',
                          value: 'View Data',
                          icon: Icons.history,
                          onTap: () {
                            // TODO: Navigate to History page
                          },
                        ),
                      ],
                    ),
                  ),
                  // Disclaimer/Safety message.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Disclaimer: The app is for informational purposes only. Always consult your doctor.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Show manual entry form for adding a new reading.
          _showManualEntryForm(context);
        },
      ),
    );
  }

  // Manual glucose entry form with input validation.
  void _showManualEntryForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double? newGlucose;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Glucose Reading'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Glucose Level (mg/dL)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid positive number';
                }
                return null;
              },
              onSaved: (value) {
                newGlucose = double.tryParse(value!);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    currentGlucose = newGlucose!;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap; // Optional tap handler for cards

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
