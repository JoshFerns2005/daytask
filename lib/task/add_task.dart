import 'package:daytask/services/supabase_service.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [];

  DateTime? _dueDateTime;
  bool _isLoading = false;

  Future<void> _selectDueDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDateTime ?? DateTime.now()),
      );

      if (timePicked != null) {
        setState(() {
          _dueDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  void _addSubtaskField() {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    for (final controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF212832),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color(0xFF212832),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Task Title",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF455A64),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Details
            TextField(
              controller: _detailsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Task Details",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF455A64),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Due date & time
            GestureDetector(
              onTap: () => _selectDueDateTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF455A64),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      _dueDateTime == null
                          ? 'Select Due Date & Time'
                          : '${_dueDateTime!.toLocal()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subtasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtasks',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _addSubtaskField,
                ),
              ],
            ),
            ..._subtaskControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Subtask",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF455A64),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      try {
                        // Debugging output to check controllers and their values
                        print(
                            "Subtask Controllers Length: ${_subtaskControllers.length}");
                        _subtaskControllers.forEach((controller) {
                          print("Subtask Text: ${controller.text}");
                        });

                        // Safely map subtasks, skipping null or empty controllers
                        final List<Map<String, dynamic>> subtasks =
                            _subtaskControllers
                                .where((controller) =>
                                    controller != null &&
                                    controller.text.trim().isNotEmpty)
                                .map((controller) => {
                                      'title': controller.text.trim(),
                                      'is_completed': false
                                    })
                                .toList();

                        // Call create task method
                        await SupabaseService().createTask(
                          title: _titleController.text,
                          details: _detailsController.text,
                          dueDateTime: _dueDateTime!,
                          subtasks: subtasks,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Task created successfully!')),
                        );

                        // Clear controllers
                        _titleController.clear();
                        _detailsController.clear();
                        for (final controller in _subtaskControllers) {
                          controller.clear();
                        }
                        setState(() {
                          _subtaskControllers.clear();
                          _dueDateTime = null;
                          _isLoading = false;
                        });
                      } catch (e) {
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Create Task',
                      style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
