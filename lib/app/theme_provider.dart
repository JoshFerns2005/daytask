import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  // Light Theme
  final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF6F8793), // Updated color
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6F8793),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Color(0xFF6F8793)),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFED36A),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFFED36A)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF455A64),
      textColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF263238),
      selectedItemColor: Color(0xFFFED36A),
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: ColorScheme.light(
      secondary: const Color(0xFFFED36A), // Define the desired color
    ),
  );
  // Dark Theme
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF212832),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF212832),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFED36A),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFF455A64),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white70),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFFED36A)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF455A64),
      textColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF263238),
      selectedItemColor: Color(0xFFFED36A),
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: ColorScheme.dark(
      secondary: const Color(0xFFFED36A), // Define the desired color
    ),
  );
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark =
        prefs.getBool('isDark') ?? true; // Default to dark mode if not set
    notifyListeners();
  }

  // Toggle the theme mode and save it to SharedPreferences
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = !_isDark;
    await prefs.setBool('isDark', _isDark); // Save the new theme mode
    notifyListeners();
  }
}
