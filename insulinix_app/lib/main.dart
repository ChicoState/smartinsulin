import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // ✅ add this
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Activate App Check with Debug Provider
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(const InsulinixApp());
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
