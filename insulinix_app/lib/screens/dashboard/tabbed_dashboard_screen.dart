import 'package:flutter/material.dart';
import 'monitor_screen.dart';
import 'add_note_screen.dart';
import 'pod_status_screen.dart';

class TabbedDashboardScreen extends StatelessWidget {
  const TabbedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monitor_heart), text: "Monitor"),
              Tab(icon: Icon(Icons.note_add), text: "Notes"),
              Tab(icon: Icon(Icons.devices), text: "Pod Status"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MonitorScreen(),
            AddNoteScreen(),
            PodStatusScreen(),
          ],
        ),
      ),
    );
  }
}
