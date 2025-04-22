import 'package:daytask/auth/login_screen.dart';
import 'package:daytask/profile/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/theme_provider.dart'; // Import your ThemeProvider

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;

  String? fullName;
  String? email;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    email = user.email; // Getting email from the auth user

    final response = await supabase
        .from('users') // Your custom users table
        .select('full_name')
        .eq('uid',
            user.id) // 'uid' refers to the user ID in the auth.users table
        .single();

    setState(() {
      fullName = response['full_name'];
      loading = false;
    });
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.05; // 5% of screen width
    final double iconSize = screenWidth * 0.06; // 6% of screen width
    final double fontSizeMedium = screenWidth * 0.035; // 3.5% of screen width
    final double fontSizeSmall = screenWidth * 0.03; // 3% of screen width
    final double borderRadius = screenWidth * 0.02; // 2% of screen width
    final double buttonHeight = screenHeight * 0.06; // 6% of screen height
    final double fontSizeLarge = screenWidth * 0.04; // 4% of screen width
    final double avatarRadius = screenWidth * 0.1; // 10% of screen width

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: fontSizeLarge,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(basePadding), // Responsive padding
              child: Column(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: avatarRadius, // Responsive radius
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Icon(
                      Icons.person,
                      size: iconSize, // Responsive icon size
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Responsive spacing

                  // Username displayed as a ListTile
                  ListTile(
                    tileColor: Theme.of(context).listTileTheme.tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Responsive border radius
                    ),
                    leading: Icon(
                      Icons.person,
                      size: iconSize, // Responsive icon size
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      fullName ?? 'Loading...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: fontSizeMedium, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    onTap: () {
                      // TODO: Add actions if needed
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing

                  // Email displayed as a ListTile
                  ListTile(
                    tileColor: Theme.of(context).listTileTheme.tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Responsive border radius
                    ),
                    leading: Icon(
                      Icons.email,
                      size: iconSize, // Responsive icon size
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      email ?? 'Loading...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: fontSizeMedium, // Responsive font size
                          ),
                    ),
                    onTap: () {
                      // TODO: Add actions if needed
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing

                  // Settings ListTile
                  ListTile(
                    tileColor: Theme.of(context).listTileTheme.tileColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Responsive border radius
                    ),
                    leading: Icon(
                      Icons.settings,
                      size: iconSize, // Responsive icon size
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      "Settings",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: fontSizeMedium, // Responsive font size
                          ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: fontSizeSmall, // Responsive icon size
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SettingsScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                                Offset(1.0, 0.0); // Start from the right
                            const end = Offset.zero; // End at the center
                            const curve =
                                Curves.easeInOut; // Smooth easing curve

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
                  SizedBox(height: screenHeight * 0.04), // Responsive spacing

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .elevatedButtonTheme
                            .style
                            ?.backgroundColor
                            ?.resolve({}),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: buttonHeight * 0.3), // Responsive padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadius), // Responsive border radius
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            size: iconSize, // Responsive icon size
                            color: Colors.black,
                          ),
                          SizedBox(width: basePadding), // Responsive spacing
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: fontSizeMedium, // Responsive font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
