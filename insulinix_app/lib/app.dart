import 'package:flutter/material.dart';
import 'routes/app_routes.dart';


class InsulinixApp extends StatelessWidget {
  const InsulinixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insulinix',
      theme: ThemeData.dark(), // Customize in app_theme.dart
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
