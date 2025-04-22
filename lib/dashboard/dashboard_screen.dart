import 'package:daytask/task/task_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app/theme_provider.dart';
import '../utils/task_provider.dart';
import 'task_completed_card.dart';
import 'ongoing_project_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(0), // Initialize with a dummy taskId
      child: _DashboardScreenContent(),
    );
  }
}

class _DashboardScreenContent extends StatefulWidget {
  const _DashboardScreenContent();

  @override
  State<_DashboardScreenContent> createState() =>
      _DashboardScreenContentState();
}

class _DashboardScreenContentState extends State<_DashboardScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  String fullName = "Loading...";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    fetchUserName();
    Provider.of<TaskProvider>(context, listen: false).fetchOngoingProjects();
    Provider.of<TaskProvider>(context, listen: false).fetchCompletedTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('full_name')
          .eq('uid', user.id)
          .single();
      setState(() {
        fullName = response['full_name'] ?? 'User';
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    Provider.of<TaskProvider>(context, listen: false).filterTasks(query);
  }

  Future<void> _refresh() async {
    await fetchUserName();
    Provider.of<TaskProvider>(context, listen: false).fetchOngoingProjects();
    Provider.of<TaskProvider>(context, listen: false).fetchCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight:
            screenHeight * 0.15, // Responsive height (15% of screen height)
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back!",
              style: TextStyle(
                fontSize: screenWidth *
                    0.04, // Responsive font size (4% of screen width)
                color: Color(0xFFFED36A),
              ),
            ),
            Text(
              fullName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontFamily: "PilatExtended",
                fontSize: screenWidth *
                    0.05, // Responsive font size (5% of screen width)
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: screenWidth *
                    0.04), // Responsive padding (4% of screen width)
            child: CircleAvatar(
              radius:
                  screenWidth * 0.06, // Responsive radius (6% of screen width)
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: screenWidth *
                    0.08, // Responsive icon size (8% of screen width)
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width *
            0.05), // Responsive padding (5% of screen width)
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: MediaQuery.of(context).size.width *
                        0.035, // Responsive font size (3.5% of screen width)
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: MediaQuery.of(context).size.width *
                        0.05, // Responsive icon size (5% of screen width)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context)
                            .size
                            .width *
                        0.02), // Responsive border radius (2% of screen width)
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: MediaQuery.of(context).size.width *
                          0.04, // Responsive font size (4% of screen width)
                    ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Responsive spacing (3% of screen height)
              Text(
                "Completed Projects",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.04, // Responsive font size (4% of screen width)
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.015), // Responsive spacing (1.5% of screen height)
              // Completed Tasks
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.25, // Responsive height (30% of screen height)
                child: taskProvider.filteredCompletedTasks.isEmpty
                    ? Center(
                        child: Text(
                          "No completed tasks found",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: MediaQuery.of(context).size.width *
                                0.035, // Responsive font size (3.5% of screen width)
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: taskProvider.filteredCompletedTasks.length,
                        itemBuilder: (context, index) {
                          final task =
                              taskProvider.filteredCompletedTasks[index];
                          return TaskCompletedCard(
                            taskId: task['id'], // Pass only the taskId
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      TaskDetailsScreen(
                                    taskId: task['id'],
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin =
                                        Offset(0, 1); // Start from the bottom
                                    const end =
                                        Offset.zero; // End at the center
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                      milliseconds:
                                          500), // Duration of the animation
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.03), // Responsive spacing (3% of screen height)
// Ongoing Projects
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongoing Projects",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.04, // Responsive font size (4% of screen width)
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  if (taskProvider.filteredOngoingProjects.isNotEmpty)
                    Text(
                      "${taskProvider.filteredOngoingProjects.length} projects",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *
                            0.03, // Responsive font size (3% of screen width)
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                ],
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.015), // Responsive spacing (1.5% of screen height)
              taskProvider.filteredOngoingProjects.isEmpty
                  ? Center(
                      child: Text(
                        "No ongoing projects found",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.035, // Responsive font size (3.5% of screen width)
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskProvider.filteredOngoingProjects.length,
                      itemBuilder: (context, index) {
                        final project =
                            taskProvider.filteredOngoingProjects[index];
                        return OngoingProjectCard(
                          taskId: project['id'], // Pass only the taskId
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        TaskDetailsScreen(
                                  taskId: project['id'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin =
                                      Offset(0, 1); // Start from the bottom
                                  const end = Offset.zero; // End at the center
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds:
                                        500), // Duration of the animation
                              ),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
