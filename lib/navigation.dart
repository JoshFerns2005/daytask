import 'package:daytask/dashboard/dashboard_screen.dart';
import 'package:daytask/profile/profile_screen.dart';
import 'package:daytask/task/add_task.dart';
import 'package:flutter/material.dart';
// import other screens like CalendarScreen, AlertsScreen, ProfileScreen if needed

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(
        child: Text("Calendar", style: TextStyle(color: Colors.white))),
    const CreateTaskScreen(),
    const Center(child: Text("Alerts", style: TextStyle(color: Colors.white))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFED36A),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF263238),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0,12,0,6), // Adjust padding here for alignment
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFFED36A),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Icon(Icons.add_box_outlined, color: Colors.black),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded), label: "Alerts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
