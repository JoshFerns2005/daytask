import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'task_completed_card.dart';
import 'ongoing_project_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String fullName = "Loading...";
  List<Map<String, dynamic>> ongoingProjects = [];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchOngoingProjects();
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

  Future<void> fetchOngoingProjects() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('tasks')
          .select('id, title, due_datetime, subtasks')
          .eq('uid', user.id)
          .eq('completed', false) // Only ongoing tasks
          .order('due_datetime', ascending: true) // Order by due date
;
      if (response != null) {
        List<Map<String, dynamic>> tasks = [];
        for (var task in response) {
          // Calculate the percentage of completion
          int completedSubtasks = 0;
          List<dynamic> subtasks = task['subtasks'];
          if (subtasks != null) {
            for (var subtask in subtasks) {
              if (subtask['is_completed'] == true) {
                // Use 'is_completed' here
                completedSubtasks++;
              }
            }
          }

          double percentage = (completedSubtasks / subtasks.length * 100).toDouble();

          // Add the task with percentage to the ongoingProjects list
          tasks.add({
            'id': task['id'],
            'title': task['title'],
            'due_datetime': task['due_datetime'],
            'percentage': percentage,
          });
        }

        setState(() {
          ongoingProjects = tasks;
        });
      } else {
        print('Error fetching ongoing projects: ${response}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212832),
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF212832),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome back!",
              style: TextStyle(fontSize: 16, color: Color(0xFFFED36A)),
            ),
            Text(
              fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "PilatExtended",
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: const TextStyle(color: Color(0xFF6F8793)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6F8793)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                filled: true,
                fillColor: const Color(0xFF455A64),
              ),
            ),
            const SizedBox(height: 24),

            // Completed Tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Completed Tasks",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: const Text("See All",
                        style: TextStyle(color: Color(0xFFFED36A)))),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TaskCompletedCard(title: "UI Design"),
                  TaskCompletedCard(title: "API Setup"),
                  TaskCompletedCard(title: "Onboarding Flow"),
                  TaskCompletedCard(title: "Testing"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ongoing Projects
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ongoing Projects",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: const Text("See All",
                        style: TextStyle(color: Color(0xFFFED36A)))),
              ],
            ),
            const SizedBox(height: 12),
            ongoingProjects.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: ongoingProjects.length,
                    itemBuilder: (context, index) {
                      var project = ongoingProjects[index];
                      return OngoingProjectCard(
                        title: project['title'],
                        dueDate: project['due_datetime'],
                        percent: project['percentage'],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
