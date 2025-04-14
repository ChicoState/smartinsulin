import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _insulinIdController = TextEditingController();
  final _providerCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _insulinIdController.dispose();
    _providerCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //void _onNext() {
   // Navigator.pushNamed(context, '/setup-intro');
  //}
  void _onNext() async {
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match')),
    );
    return;
  }

  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _insulinIdController.text.trim(), // Insulin ID = Email
      password: _passwordController.text.trim(),
    );

    // ✅ Store extra user info in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credential.user?.uid)
        .set({
          'name': _nameController.text.trim(),
          'providerCode': _providerCodeController.text.trim(),
          'insulinId': _insulinIdController.text.trim(),
          'createdAt': Timestamp.now(),
        });

    Navigator.pushNamed(context, '/setup-intro');
  } on FirebaseAuthException catch (e) {
    String message = 'Signup failed';
    if (e.code == 'email-already-in-use') {
      message = 'That email is already in use.';
    } else if (e.code == 'weak-password') {
      message = 'Password is too weak.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle add device later
            },
            child: const Text('ADD DEVICE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildField("Name", _nameController),
            _buildField("Email", _insulinIdController),
            _buildField("Healthcare provider code", _providerCodeController),
            _buildField("Password", _passwordController, obscure: true),
            _buildField("Confirm Password", _confirmPasswordController, obscure: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          // hintText: 'Enter your $label',
          hintStyle: const TextStyle(color: Colors.black),
          filled: true,
          border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6), 
                    borderSide: BorderSide(color: Colors.black, width: 1),),
          //labelStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

// TextField(
//                 controller: _idController,
                
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   hintText: 'Enter your email',
//                   hintStyle: const TextStyle(color: Colors.black),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6), 
//                     borderSide: BorderSide(color: Colors.black, width: 1),),
//                 ),
//                 style: const TextStyle(color: Colors.black),
//               ),
