import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //void _handleSignIn() {
    // Implement sign-in logic
    //print('ID: ${_idController.text}, Password: ${_passwordController.text}');
    
  //}
  void _handleSignIn() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _idController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Navigator.pushNamed(context, '/dashboard'); // or wherever you want to go
  } on FirebaseAuthException catch (e) {
    String message = 'Login failed';
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 200),
              // const Text('INSULIN ID'),
              // const SizedBox(height: 8),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  //fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6), 
                    borderSide: BorderSide(color: Colors.black, width: 1),),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              // const Text('PASSWORD'),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  //fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6), 
                    borderSide: BorderSide(color: Colors.black, width: 1),),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password
                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SIGN IN'),
              ),
              const Spacer(),
              const Center(child: Text("Don’t have an account?")),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
