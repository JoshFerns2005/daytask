import 'package:daytask/dashboard/dashboard_screen.dart';
import 'package:daytask/profile/profile_screen.dart';
import 'package:daytask/task/add_task.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CreateTaskScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.04; // 4% of screen width
    final double iconSize = screenWidth * 0.06; // 6% of screen width
    final double containerHeight = screenHeight * 0.05; // 5% of screen height
    final double borderRadius = screenWidth * 0.02; // 2% of screen width

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFED36A), // Dynamic color
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color, // Dynamic color
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor, // Dynamic color
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: iconSize),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0, basePadding, 0, basePadding / 2), // Responsive padding
              child: Container(
                height: containerHeight, // Responsive height
                padding: EdgeInsets.symmetric(
                  horizontal: basePadding * 1.5, // Responsive horizontal padding
                  vertical: basePadding / 2, // Responsive vertical padding
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFED36A), // Dynamic color
                  borderRadius: BorderRadius.circular(borderRadius), // Responsive border radius
                ),
                child: Icon(
                  Icons.add_box_outlined,
                  size: iconSize, // Responsive icon size
                  color: Theme.of(context).iconTheme.color, // Dynamic color
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, size: iconSize),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}