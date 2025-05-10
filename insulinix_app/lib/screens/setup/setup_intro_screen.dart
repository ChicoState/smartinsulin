import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetupIntroScreen extends StatefulWidget {
  const SetupIntroScreen({super.key});

  @override
  State<SetupIntroScreen> createState() => _SetupIntroScreenState();
}

class _SetupIntroScreenState extends State<SetupIntroScreen> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            userName = doc['name'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching name: $e');
      setState(() {
        userName = "User";
        isLoading = false;
      });
    }
  }

  void _goToNext(BuildContext context) {
    Navigator.pushNamed(context, '/setup-bolus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SETUP")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome to Insulinx, $userName!",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Let's get your setup started!",
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 40),
                      onPressed: () => _goToNext(context),
                    ),
                    const SizedBox(height: 40),
                    // 🛡️ Health & Safety Warning Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: const Text(
                        "⚠️ Important Health Warning:\n\n"
                        "This system is intended for individuals with Type 2 Diabetes. "
                        "Always consult your healthcare provider before making changes to your insulin or CGM settings. "
                        "Use this device safely and according to medical advice.",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
