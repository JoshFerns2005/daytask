import 'package:daytask/auth/login_screen.dart';
import 'package:daytask/dashboard/dashboard_screen.dart';
import 'package:daytask/navigation.dart';
import 'package:daytask/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://arzeuzhyjmthudgpgozn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFyemV1emh5am10aHVkZ3Bnb3puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNjc4MDgsImV4cCI6MjA2MDc0MzgwOH0.EWluHf_LLvi5i6cpLdlb766oXjIsRPuwglWF6BXt7zI',
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DayTask',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/navigation': (context) => const MainNavigation(),
      },
    );
  }
}
