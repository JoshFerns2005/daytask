import 'package:daytask/dashboard/dashboard_screen.dart';
import 'package:daytask/navigation.dart';
import 'package:daytask/profile/settings_screen.dart';
import 'package:daytask/splash_screen.dart';
import 'package:daytask/task/task_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme_provider.dart'; // Import your ThemeProvider
import 'package:daytask/auth/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://arzeuzhyjmthudgpgozn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFyemV1emh5am10aHVkZ3Bnb3puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNjc4MDgsImV4cCI6MjA2MDc0MzgwOH0.EWluHf_LLvi5i6cpLdlb766oXjIsRPuwglWF6BXt7zI',
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );

  // Initialize ThemeProvider and load the saved theme mode
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode(); // Load the saved theme mode

  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider, // Use the same instance of ThemeProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DayTask',
      theme: themeProvider.lightTheme, // Use light theme
      darkTheme: themeProvider.darkTheme, // Use dark theme
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/navigation': (context) => const MainNavigation(),
        '/dashboard': (context) => const DashboardScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/task': (context) {
          final taskId = ModalRoute.of(context)!.settings.arguments as int;
          return TaskDetailsScreen(taskId: taskId);
        },
      },
    );
  }
}