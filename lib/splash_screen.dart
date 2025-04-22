import 'package:daytask/auth/login_screen.dart';
import 'package:daytask/navigation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212832), // Light background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Image at the top left
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
            child: Image.asset(
              'assets/images/logo.png', // Replace with your logo asset path
              width: 100, // Adjust as needed
            ),
          ),
          // Big Image below
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Image.asset(
              'assets/images/Splash.png', // Replace with your logo asset path
              width: double.infinity, // Adjust as needed
            ),
          ),
          // Text below the image
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
            child: Text(
              'Manage your \nTask with',
              style: TextStyle(
                fontFamily: 'PilatExtended',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Text(
              'DayTask',
              style: TextStyle(
                fontFamily: 'PilatExtended',
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFED36A), // Text color
              ),
            ),
          ),
          // Let's start button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: () {
                  final user = Supabase.instance.client.auth.currentUser;

                  if (user != null) {
                    // Navigate to dashboard with slide transition
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const MainNavigation(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0), // Slide from right
                              end: Offset.zero, // End at the center
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  } else {
                    // Navigate to login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                },
                child: const Text('Let\'s Start'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFED36A), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}