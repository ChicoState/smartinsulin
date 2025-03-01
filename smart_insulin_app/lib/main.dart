import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your home screen

void main() {
  runApp(SmartInsulinApp());
}

class SmartInsulinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartInsulin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

