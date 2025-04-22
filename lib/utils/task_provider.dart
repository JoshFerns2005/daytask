import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskProvider with ChangeNotifier {
  final int taskId;

  TaskProvider(this.taskId) {
    fetchTaskDetails();
    fetchOngoingProjects();
    fetchCompletedTasks();
  }

  bool isLoading = true;
  bool isEditing = false;

  String title = '';
  String details = '';
  DateTime? dueDate;
  List<Map<String, dynamic>> subtasks = [];

  // Lists for ongoing and completed tasks
  List<Map<String, dynamic>> _ongoingProjects = [];
  List<Map<String, dynamic>> _completedTasks = [];

  // Filtered lists for search functionality
  List<Map<String, dynamic>> filteredOngoingProjects = [];
  List<Map<String, dynamic>> filteredCompletedTasks = [];

  // Getters for ongoing and completed tasks
  List<Map<String, dynamic>> get ongoingProjects => _ongoingProjects;
  List<Map<String, dynamic>> get completedTasks => _completedTasks;

  Future<void> fetchTaskDetails() async {
    isLoading = true;
    notifyListeners();

    final response = await Supabase.instance.client
        .from('tasks')
        .select()
        .eq('id', taskId)
        .single();

    title = response['title'];
    details = response['details'] ?? '';
    dueDate = response['due_datetime'] != null
        ? DateTime.parse(response['due_datetime'])
        : null;
    subtasks = List<Map<String, dynamic>>.from(response['subtasks'] ?? []);

    isLoading = false;
    notifyListeners();
  }

Future<void> fetchOngoingProjects() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user != null) {
    final response = await Supabase.instance.client
        .from('tasks')
        .select('id, title, due_datetime, subtasks')
        .eq('uid', user.id)
        .eq('completed', false) // Fetch only ongoing tasks
        .order('due_datetime', ascending: true);
    if (response != null) {
      List<Map<String, dynamic>> tasks = [];
      for (var task in response) {
        int completedSubtasks = 0;
        List<dynamic> subtasks = task['subtasks'] ?? [];
        if (subtasks.isNotEmpty) {
          for (var subtask in subtasks) {
            if (subtask['is_completed'] == true) {
              completedSubtasks++;
            }
          }
        }
        double percentage = subtasks.isEmpty
            ? 0
            : (completedSubtasks / subtasks.length * 100).toDouble();
        tasks.add({
          'id': task['id'],
          'title': task['title'],
          'due_datetime': task['due_datetime'],
          'percentage': percentage,
        });
      }
      // Replace setState with notifyListeners
      _ongoingProjects = tasks;
      filteredOngoingProjects = tasks; // Initialize filtered list
      notifyListeners(); // Notify listeners of the state change
    } else {
      print('Error fetching ongoing projects: ${response}');
    }
  }
}
Future<void> fetchCompletedTasks() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user != null) {
    final response = await Supabase.instance.client
        .from('tasks')
        .select('id, title, due_datetime')
        .eq('uid', user.id)
        .eq('completed', true) // Fetch only completed tasks
        .order('due_datetime', ascending: false);
    if (response != null) {
      // Replace setState with notifyListeners
      _completedTasks = List<Map<String, dynamic>>.from(response);
      filteredCompletedTasks = completedTasks; // Initialize filtered list
      notifyListeners(); // Notify listeners of the state change
    } else {
      print('Error fetching completed tasks: ${response}');
    }
  }
}

  void filterTasks(String query) {
    query = query.toLowerCase().trim();
    filteredOngoingProjects = _ongoingProjects
        .where((project) => project['title'].toLowerCase().contains(query))
        .toList();
    filteredCompletedTasks = _completedTasks
        .where((task) => task['title'].toLowerCase().contains(query))
        .toList();
    notifyListeners();
  }

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDetails(String newDetails) {
    details = newDetails;
    notifyListeners();
  }

  void updateDueDate(DateTime? newDate) {
    dueDate = newDate;
    notifyListeners();
  }

  void addSubtask(String subtaskTitle) {
    subtasks.add({'title': subtaskTitle, 'is_completed': false});
    notifyListeners();
  }

  void removeSubtask(int index) {
    subtasks.removeAt(index);
    notifyListeners();
  }

  Future<void> toggleSubtaskCompletion(int index, bool? isChecked) async {
    final updatedSubtasks = [...subtasks];
    updatedSubtasks[index]['is_completed'] = isChecked ?? false;

    // Check if all subtasks are completed
    final allCompleted =
        updatedSubtasks.every((subtask) => subtask['is_completed'] == true);

    // Update the task's completion status in the database
    await Supabase.instance.client.from('tasks').update({
      'subtasks': updatedSubtasks,
      'completed':
          allCompleted, // Mark task as completed if all subtasks are done
    }).eq('id', taskId);

    // Refresh local data
    await fetchTaskDetails();
  }

  void updateSubtaskTitle(int index, String title) {
    subtasks[index]['title'] = title;
    notifyListeners();
  }

  Future<void> saveTask() async {
    isLoading = true;
    notifyListeners();

    await Supabase.instance.client.from('tasks').upsert({
      'id': taskId,
      'title': title,
      'details': details,
      'due_datetime': dueDate?.toIso8601String(),
      'subtasks': subtasks,
    });

    isEditing = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(BuildContext context) async {
    await Supabase.instance.client.from('tasks').delete().eq('id', taskId);
    Navigator.pop(context); // or pushReplacementNamed to task list
  }
}
