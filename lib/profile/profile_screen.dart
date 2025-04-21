import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212832),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212832),
        automaticallyImplyLeading: false,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFED36A)))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 50),

                  // Username displayed as a ListTile
                  ListTile(
                    tileColor: const Color(0xFF455A64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      fullName ?? 'Loading...',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // TODO: Add actions if needed
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email displayed as a ListTile
                  ListTile(
                    tileColor: const Color(0xFF455A64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: const Icon(Icons.email, color: Colors.white),
                    title: Text(
                      email ?? 'Loading...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {
                      // TODO: Add actions if needed
                    },
                  ),
                  const SizedBox(height: 24),

                  // Settings (same as before)
                  ListTile(
                    tileColor: const Color(0xFF455A64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("Settings",
                        style: TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 16),
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                  const SizedBox(height: 24),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFED36A),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row takes only as much space as necessary
                        children: const [
                          Icon(Icons.exit_to_app,
                              color:
                                  Colors.black), // Add an icon before the text
                          SizedBox(
                              width: 8), // Space between the icon and the text
                          Text(
                            "Logout",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
