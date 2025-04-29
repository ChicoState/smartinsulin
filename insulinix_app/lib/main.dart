import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';
import 'controllers/bluetooth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => BluetoothController(), // Create a single instance
      child: const InsulinixApp(), // Your existing app widget
    ),);
}

class InsulinixApp extends StatelessWidget {
  const InsulinixApp({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Insulin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: user == null ? '/' : '/dashboard',
      routes: appRoutes,
    );
  }
}