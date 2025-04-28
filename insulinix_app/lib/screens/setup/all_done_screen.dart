import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllDoneScreen extends StatefulWidget {
  const AllDoneScreen({super.key});

  @override
  State<AllDoneScreen> createState() => _AllDoneScreenState();
}

class _AllDoneScreenState extends State<AllDoneScreen> {
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
      print('Error fetching user name: $e');
      setState(() {
        userName = "User"; // fallback
        isLoading = false;
      });
    }
  }

  void _goToDeviceScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ALL SET!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome, $userName!",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    const Icon(Icons.check_circle, size: 100, color: Colors.black),
                    const SizedBox(height: 24),
                    const Text(
                      "Your device has been linked to your account!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _goToDeviceScreen(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("OK!"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
