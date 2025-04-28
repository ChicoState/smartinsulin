import 'package:flutter/material.dart';
import '../screens/launch/launch_screen.dart';
import '../screens/auth/signin_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/setup/setup_intro_screen.dart';
import '../screens/setup/setup_bolus_screen.dart';
import '../screens/setup/all_done_screen.dart';
import '../screens/dashboard/main_device_screen.dart';
import '../screens/dashboard/monitor_screen.dart';
import '../screens/dashboard/add_note_screen.dart';
import '../screens/dashboard/pod_status_screen.dart';
import '../screens/dashboard/tabbed_dashboard_screen.dart';
import '../screens/errors/error_overlay_screen.dart';
import '../screens/errors/error_detail_screen.dart';
import '../screens/errors/error_notification_screen.dart';
import '../screens/auth/userprofile_screen.dart';
import '../screens/dashboard/components/chatbox_screen.dart';
import '../screens/dashboard/components/gemini_api.dart';
import '../screens/dashboard/profile_screen.dart';
import '../screens/dashboard/settings_screen.dart';
import '../screens/dashboard/schedules_screen.dart';
import '../screens/dashboard/account_screen.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const LaunchScreen(),
  '/signin': (_) => const SignInScreen(),
  '/signup': (_) => const SignUpScreen(),
  '/setup-intro': (_) => const SetupIntroScreen(),
  '/setup-bolus': (_) => const SetupBolusScreen(),
  '/all-done': (_) => const AllDoneScreen(),
  '/device': (_) => const MainDeviceScreen(),
  '/monitor': (_) => const MonitorScreen(),
  '/add-note': (_) => const AddNoteScreen(),
  '/pod-status': (_) => const PodStatusScreen(),
  '/dashboard': (_) => const TabbedDashboardScreen(),
  '/error-overlay': (_) => const ErrorOverlayScreen(),
  '/error-detail': (_) => const ErrorDetailScreen(),
  '/error-notification': (_) => const ErrorNotificationScreen(),
  '/profile': (_) => const UserProfileScreen(),
  '/chatbox': (_) => const ChatBoxScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/settings': (_) => const SettingsScreen(),
  '/schedules': (_) => const SchedulesScreen(),
  '/account': (_) => const AccountScreen(),

};
