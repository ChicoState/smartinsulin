import 'package:flutter/material.dart';
import 'monitor_screen.dart';
import 'add_note_screen.dart';
import 'pod_status_screen.dart';
import 'components/chatbox_screen.dart';
import 'components/drawer_menu.dart';
import 'components/cgm_tile.dart';
import 'components/glucose_data.dart';

class TabbedDashboardScreen extends StatelessWidget {
  const TabbedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const DrawerMenu(), // ✅ Added DrawerMenu
        appBar: AppBar(
          title: const Text("Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monitor), text: 'Monitor'),
              Tab(icon: Icon(Icons.note), text: 'Notes'),
              Tab(icon: Icon(Icons.devices), text: 'Pod Status'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MonitorScreen(),   // Monitor screen - we'll update to show CGMTile inside
            AddNoteScreen(),
            PodStatusScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.chat_bubble_outline),
          tooltip: 'Chat Assistant',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatBoxScreen()),
            );
          },
        ),
      ),
    );
  }
}
