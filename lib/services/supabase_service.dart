import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Create a new task with optional subtasks
  Future<void> createTask({ required String title, required String details,required  DateTime dueDateTime,
      required List<Map<String, dynamic>> subtasks}) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      // Prepare task data
      final task = {
        'uid': userId,
        'title': title,
        'details': details,
        'due_datetime': dueDateTime.toIso8601String(),
        'subtasks': subtasks,
        'completed': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await supabase.from('tasks').insert([task]);

   
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Edit task title and details
  Future<void> editTask(int taskId, String title, String details) async {
    try {
      final response = await supabase.from('tasks').update({
        'title': title,
        'details': details,
      }).eq('id', taskId);

      if (response.error != null) {
        throw Exception('Failed to edit task: ${response.error?.message}');
      }
    } catch (e) {
      throw Exception('Failed to edit task: $e');
    }
  }

  // Update task due date & time
  Future<void> updateTaskDueDate(int taskId, DateTime newDueDateTime) async {
    try {
      final response = await supabase.from('tasks').update({
        'due_datetime': newDueDateTime.toIso8601String(),
      }).eq('id', taskId);

      if (response.error != null) {
        throw Exception('Failed to update due date: ${response.error?.message}');
      }
    } catch (e) {
      throw Exception('Failed to update due date: $e');
    }
  }

  // Update subtasks
  Future<void> updateSubtasks(
      int taskId, List<Map<String, dynamic>> newSubtasks) async {
    try {
      final response = await supabase.from('tasks').update({
        'subtasks': newSubtasks,
      }).eq('id', taskId);

      if (response.error != null) {
        throw Exception('Failed to update subtasks: ${response.error?.message}');
      }
    } catch (e) {
      throw Exception('Failed to update subtasks: $e');
    }
  }

  // Delete task by ID
  Future<void> deleteTask(int taskId) async {
    try {
      final response = await supabase.from('tasks').delete().eq('id', taskId);

      if (response.error != null) {
        throw Exception('Failed to delete task: ${response.error?.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Get all ongoing tasks for current user
  Future<List<Map<String, dynamic>>> getTasks() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await supabase
          .from('tasks')
          .select()
          .eq('uid', userId)
          .eq('completed', false); // Only ongoing tasks

      if (response != null) {
        throw Exception('Failed to fetch tasks: ${response}');
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  // Get a specific task by ID
  Future<Map<String, dynamic>?> getTaskById(int taskId) async {
    try {
      final response =
          await supabase.from('tasks').select().eq('id', taskId).single();

      if (response != null) {
        throw Exception('Failed to fetch task: ${response}');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }
}

