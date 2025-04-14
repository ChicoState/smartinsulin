import 'package:flutter/material.dart';

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

  void _onNext() {
    Navigator.pushNamed(context, '/setup-intro');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN UP'),
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
            _buildField("Create insulinix ID", _insulinIdController),
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
              child: const Text('NEXT'),
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
          filled: true,
          fillColor: Colors.black54,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
