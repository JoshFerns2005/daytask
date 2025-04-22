import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme_provider.dart'; // Import your ThemeProvider

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.05; // 5% of screen width
    final double fontSizeLarge = screenWidth * 0.04; // 4% of screen width
    final double fontSizeMedium = screenWidth * 0.035; // 3.5% of screen width
    final double dividerThickness = screenWidth * 0.005; // 0.5% of screen width

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: fontSizeLarge,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(basePadding), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Toggle Section
            Text(
              "Appearance",
              style: TextStyle(
                fontSize: fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontSize: fontSizeMedium,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return Switch(
                      value: themeProvider.isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: const Color(0xFFFED36A), // Use secondary color
                    );
                  },
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: dividerThickness, // Responsive divider thickness
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive spacing

            // Privacy Policy Section
            Text(
              "Legal",
              style: TextStyle(
                fontSize: fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            ListTile(
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: fontSizeMedium,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).iconTheme.color,
                size: fontSizeMedium, // Responsive icon size
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PrivacyPolicyScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // Start from the right
                      const end = Offset.zero; // End at the center
                      const curve = Curves.easeInOut; // Smooth easing curve

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.05; // 5% of screen width
    final double fontSizeLarge = screenWidth * 0.04; // 4% of screen width
    final double fontSizeMedium = screenWidth * 0.035; // 3.5% of screen width

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: fontSizeLarge,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(basePadding), // Responsive padding
        child: ListView(
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            Text(
              "This app respects your privacy. We do not collect or store any personal information. "
              "All data is stored securely on your device and is never shared with third parties.\n\n"
              "For more details, please contact us at support@example.com.",
              style: TextStyle(
                fontSize: fontSizeMedium,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}