import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daytask/services/supabase_service.dart';
import 'package:daytask/utils/task_provider.dart';
import 'package:daytask/app/theme_provider.dart'; // Import your ThemeProvider

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(0), // Initialize with a dummy taskId
      child: _CreateTaskContent(),
    );
  }
}

class _CreateTaskContent extends StatefulWidget {
  const _CreateTaskContent();

  @override
  State<_CreateTaskContent> createState() => _CreateTaskContentState();
}

class _CreateTaskContentState extends State<_CreateTaskContent> {
  final List<TextEditingController> _subtaskControllers = [];
  late final TextEditingController _titleController; // Task title controller
  late final TextEditingController
      _detailsController; // Task details controller
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from TaskProvider
    _titleController = TextEditingController(text: '');
    _detailsController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    // Dispose of all controllers to avoid memory leaks
    _titleController.dispose();
    _detailsController.dispose();
    for (final controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDueDateTime(
      BuildContext context, TaskProvider taskProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: taskProvider.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(taskProvider.dueDate ?? DateTime.now()),
      );

      if (timePicked != null) {
        taskProvider.updateDueDate(DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        ));
      }
    }
  }

  void _addSubtaskField(TaskProvider taskProvider) {
    setState(() {
      _subtaskControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.05; // 5% of screen width
    final double fontSizeLarge = screenWidth * 0.04; // 4% of screen width
    final double fontSizeMedium = screenWidth * 0.035; // 3.5% of screen width
    final double fontSizeSmall = screenWidth * 0.03; // 3% of screen width
    final double borderRadius = screenWidth * 0.02; // 2% of screen width
    final double buttonHeight = screenHeight * 0.06; // 6% of screen height

    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Task',
          style: TextStyle(
              fontSize: fontSizeLarge,
              color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(basePadding), // Responsive padding
        child: ListView(
          children: [
            // Title
            TextField(
              controller: _titleController, // Use the initialized controller
              onChanged: (value) => taskProvider.updateTitle(value),
              style: TextStyle(
                  fontSize: fontSizeMedium,
                  color: Theme.of(context).textTheme.bodySmall?.color),
              decoration: InputDecoration(
                labelText: "Task Title",
                labelStyle: TextStyle(
                    fontSize: fontSizeSmall,
                    color: Theme.of(context).textTheme.bodySmall?.color),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Details
            TextField(
              controller: _detailsController, // Use the initialized controller
              onChanged: (value) => taskProvider.updateDetails(value),
              style: TextStyle(
                  fontSize: fontSizeMedium,
                  color: Theme.of(context).textTheme.bodySmall?.color),
              decoration: InputDecoration(
                labelText: "Task Details",
                labelStyle: TextStyle(
                    fontSize: fontSizeSmall,
                    color: Theme.of(context).textTheme.bodySmall?.color),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
              maxLines: 4,
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            // Due date & time
            GestureDetector(
              onTap: () => _selectDueDateTime(context, taskProvider),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: basePadding / 2, // Responsive vertical padding
                  horizontal: basePadding, // Responsive horizontal padding
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).listTileTheme.tileColor,
                  borderRadius: BorderRadius.circular(
                      borderRadius), // Responsive border radius
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: fontSizeMedium, // Responsive icon size
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: basePadding / 2), // Responsive spacing
                    Expanded(
                      child: Text(
                        taskProvider.dueDate == null
                            ? 'Select Due Date & Time'
                            : '${taskProvider.dueDate!.toLocal()}',
                        style: TextStyle(
                          fontSize: fontSizeMedium, // Responsive font size
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

// Subtasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtasks',
                  style: TextStyle(
                    fontSize: fontSizeMedium, // Responsive font size
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: fontSizeMedium, // Responsive icon size
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => _addSubtaskField(taskProvider),
                ),
              ],
            ),
            ..._subtaskControllers.map(
              (controller) => Padding(
                padding: EdgeInsets.symmetric(
                    vertical: basePadding / 5), // Responsive vertical padding
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: fontSizeSmall, // Responsive font size
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: "Subtask",
                    hintStyle: TextStyle(
                      fontSize: fontSizeSmall, // Responsive font size
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Responsive border radius
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

            // Submit
            SizedBox(
              height: buttonHeight, // Responsive button height
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        try {
                          // Safely map subtasks, skipping null or empty controllers
                          final List<Map<String, dynamic>> subtasks =
                              _subtaskControllers
                                  .where((controller) =>
                                      controller.text.trim().isNotEmpty)
                                  .map((controller) => {
                                        'title': controller.text.trim(),
                                        'is_completed': false,
                                      })
                                  .toList();

                          // Call create task method
                          await SupabaseService().createTask(
                            title: _titleController.text
                                .trim(), // Use the title from the controller
                            details: _detailsController.text
                                .trim(), // Use the details from the controller
                            dueDateTime: taskProvider.dueDate!,
                            subtasks: subtasks,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task created successfully!',
                                style: TextStyle(
                                    fontSize: fontSizeMedium,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color),
                              ),
                              backgroundColor: Theme.of(context)
                                  .snackBarTheme
                                  .backgroundColor,
                            ),
                          );

                          // Clear controllers
                          _titleController.clear(); // Clear title
                          _detailsController.clear(); // Clear details
                          for (final controller in _subtaskControllers) {
                            controller.clear();
                          }
                          setState(() {
                            _subtaskControllers.clear();
                            taskProvider.updateDueDate(null); // Reset due date
                            _isLoading = false;
                          });
                        } catch (e) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error: $e',
                                style: TextStyle(
                                    fontSize: fontSizeMedium,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color),
                              ),
                              backgroundColor: Theme.of(context)
                                  .snackBarTheme
                                  .backgroundColor,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor:
                      Theme.of(context).textTheme.bodyMedium?.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      )
                    : Text(
                        'Create Task',
                        style: TextStyle(
                            fontSize: fontSizeMedium,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
