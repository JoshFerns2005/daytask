import 'package:daytask/utils/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme_provider.dart'; // Import your ThemeProvider

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(taskId),
      child: _TaskDetailsContent(),
    );
  }
}

class _TaskDetailsContent extends StatefulWidget {
  const _TaskDetailsContent();

  @override
  State<_TaskDetailsContent> createState() => _TaskDetailsContentState();
}

class _TaskDetailsContentState extends State<_TaskDetailsContent> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late TextEditingController _subtaskController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    _subtaskController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of all controllers to avoid memory leaks
    _titleController.dispose();
    _detailsController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TaskProvider taskProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: taskProvider.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != taskProvider.dueDate) {
      taskProvider.updateDueDate(picked);
    }
  }

  void _addSubtask(TaskProvider taskProvider) {
    if (_subtaskController.text.trim().isEmpty) return;
    taskProvider.addSubtask(_subtaskController.text);
    _subtaskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define base values for responsiveness
    final double basePadding = screenWidth * 0.04; // 4% of screen width
    final double fontSizeLarge = screenWidth * 0.05; // 5% of screen width
    final double fontSizeMedium = screenWidth * 0.035; // 3.5% of screen width
    final double fontSizeSmall = screenWidth * 0.03; // 3% of screen width
    final double borderRadius = screenWidth * 0.02; // 2% of screen width
    final double progressSize = screenWidth * 0.12; // 12% of screen width
    final double strokeWidth = screenWidth * 0.01; // 1% of screen width

    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Update the controllers with the latest data from TaskProvider
    if (_titleController.text != taskProvider.title) {
      _titleController.text = taskProvider.title;
    }
    if (_detailsController.text != taskProvider.details) {
      _detailsController.text = taskProvider.details;
    }

    // Fetch task details when the provider initializes
    if (taskProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        taskProvider.fetchTaskDetails();
      });
    }

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Dynamic color
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Dynamic color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).iconTheme.color), // Dynamic color
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
              fontSize: fontSizeLarge,
              color: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.color), // Responsive font size
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              taskProvider.isEditing ? Icons.save : Icons.edit_outlined,
              color: Theme.of(context).iconTheme.color, // Dynamic color
            ),
            onPressed: taskProvider.isEditing
                ? () => taskProvider.saveTask()
                : () => taskProvider.toggleEditing(),
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color:
                      Theme.of(context).colorScheme.secondary)) // Dynamic color
          : Padding(
              padding: EdgeInsets.all(basePadding), // Responsive padding
              child: ListView(
                children: [
                  taskProvider.isEditing
                      ? TextField(
                          controller:
                              _titleController, // Use the initialized controller
                          onChanged: (value) => taskProvider.updateTitle(value),
                          style: TextStyle(
                            fontSize: fontSizeLarge, // Responsive font size
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Dynamic color
                            fontFamily: "PilatExtended",
                          ),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor), // Dynamic color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary), // Dynamic color
                            ),
                          ),
                        )
                      : Text(
                          taskProvider.title,
                          style: TextStyle(
                            fontSize: fontSizeLarge, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Dynamic color
                            fontFamily: "PilatExtended",
                          ),
                        ),
                  SizedBox(height: basePadding),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            basePadding / 2), // Responsive padding
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Dynamic color
                          borderRadius: BorderRadius.circular(
                              borderRadius), // Responsive border radius
                        ),
                        child: Icon(Icons.calendar_month_outlined,
                            color: Theme.of(context)
                                .iconTheme
                                .color), // Dynamic color
                      ),
                      SizedBox(width: basePadding / 2), // Responsive spacing
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Due Date",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color, // Dynamic color
                              fontSize: fontSizeMedium, // Responsive font size
                            ),
                          ),
                          taskProvider.isEditing
                              ? TextButton(
                                  onPressed: () =>
                                      _selectDate(context, taskProvider),
                                  child: Text(
                                    taskProvider.dueDate != null
                                        ? "${taskProvider.dueDate!.day}/${taskProvider.dueDate!.month}/${taskProvider.dueDate!.year}"
                                        : "Select Date",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color, // Dynamic color
                                      fontSize:
                                          fontSizeMedium, // Responsive font size
                                    ),
                                  ),
                                )
                              : Text(
                                  taskProvider.dueDate != null
                                      ? "${taskProvider.dueDate!.day}/${taskProvider.dueDate!.month}/${taskProvider.dueDate!.year}"
                                      : "No date set",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color, // Dynamic color
                                    fontSize:
                                        fontSizeMedium, // Responsive font size
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: basePadding), // Responsive spacing
                  Text(
                    "Project Details",
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color, // Dynamic color
                      fontSize: fontSizeMedium, // Responsive font size
                    ),
                  ),
                  SizedBox(height: basePadding / 2), // Responsive spacing
                  taskProvider.isEditing
                      ? TextField(
                          controller:
                              _detailsController, // Use the initialized controller
                          onChanged: (value) =>
                              taskProvider.updateDetails(value),
                          maxLines: 3,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color), // Dynamic color
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor), // Dynamic color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary), // Dynamic color
                            ),
                          ),
                        )
                      : Text(
                          taskProvider.details,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color, // Dynamic color
                            fontSize: fontSizeSmall, // Responsive font size
                          ),
                        ),
                  SizedBox(height: basePadding), // Responsive spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Project Progress",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color, // Dynamic color
                          fontSize: fontSizeMedium, // Responsive font size
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: progressSize, // Responsive size
                            width: progressSize, // Responsive size
                            child: CircularProgressIndicator(
                              value: taskProvider.subtasks.isEmpty
                                  ? 0
                                  : taskProvider.subtasks
                                          .where(
                                              (t) => t['is_completed'] == true)
                                          .length /
                                      taskProvider.subtasks.length,
                              backgroundColor: Theme.of(context)
                                  .dividerColor, // Dynamic color
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context)
                                    .colorScheme
                                    .secondary, // Dynamic color
                              ),
                              strokeWidth:
                                  strokeWidth, // Responsive stroke width
                            ),
                          ),
                          Text(
                            taskProvider.subtasks.isEmpty
                                ? "0%"
                                : "${((taskProvider.subtasks.where((t) => t['is_completed'] == true).length / taskProvider.subtasks.length) * 100).toInt()}%",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color, // Dynamic color
                              fontSize: fontSizeSmall, // Responsive font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: basePadding), // Responsive spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Tasks",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color, // Dynamic color
                          fontSize: fontSizeMedium, // Responsive font size
                        ),
                      ),
                      if (taskProvider.isEditing)
                        IconButton(
                          icon: Icon(Icons.add,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary), // Dynamic color
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Theme.of(context)
                                    .dialogBackgroundColor, // Dynamic color
                                title: Text(
                                  "Add Subtask",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color), // Dynamic color
                                ),
                                content: TextField(
                                  controller:
                                      _subtaskController, // Use the initialized controller
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color), // Dynamic color
                                  decoration: InputDecoration(
                                    hintText: "Subtask title",
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color), // Dynamic color
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .dividerColor), // Dynamic color
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary), // Dynamic color
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color), // Dynamic color
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _addSubtask(taskProvider);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary), // Dynamic color
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: basePadding / 2), // Responsive spacing
                  ...List.generate(taskProvider.subtasks.length, (index) {
                    final subtask = taskProvider.subtasks[index];
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: basePadding / 2), // Responsive margin
                      padding: EdgeInsets.symmetric(
                        horizontal: basePadding / 2, // Responsive padding
                        vertical: basePadding / 4, // Responsive padding
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, // Dynamic color
                        borderRadius: BorderRadius.circular(
                            borderRadius), // Responsive border radius
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (taskProvider.isEditing)
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: subtask['title']),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color, // Dynamic color
                                  fontSize:
                                      fontSizeSmall, // Responsive font size
                                ),
                                onChanged: (value) => taskProvider
                                    .updateSubtaskTitle(index, value),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          else
                            Text(
                              subtask['title'],
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color, // Dynamic color
                                fontSize: fontSizeSmall, // Responsive font size
                              ),
                            ),
                          Row(
                            children: [
                              Checkbox(
                                value: subtask['is_completed'] ?? false,
                                onChanged: (isChecked) => taskProvider
                                    .toggleSubtaskCompletion(index, isChecked),
                                activeColor: Theme.of(context)
                                    .colorScheme
                                    .secondary, // Dynamic color
                                checkColor: Theme.of(context)
                                    .iconTheme
                                    .color, // Dynamic color
                              ),
                              if (taskProvider.isEditing)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      taskProvider.removeSubtask(index),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
      bottomNavigationBar: taskProvider.isEditing
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: basePadding), // Responsive padding
                  color: Theme.of(context)
                      .bottomAppBarTheme
                      .color, // Dynamic color
                  child: SizedBox(
                    width: double.infinity,
                    height: basePadding * 2, // Responsive height
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Theme.of(context)
                                .dialogBackgroundColor, // Dynamic color
                            title: Text(
                              "Add Subtask",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color, // Dynamic color
                                fontSize:
                                    fontSizeMedium, // Responsive font size
                              ),
                            ),
                            content: TextField(
                              controller:
                                  _subtaskController, // Use the initialized controller
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color, // Dynamic color
                                fontSize: fontSizeSmall, // Responsive font size
                              ),
                              decoration: InputDecoration(
                                hintText: "Subtask title",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color, // Dynamic color
                                  fontSize:
                                      fontSizeSmall, // Responsive font size
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor), // Dynamic color
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary), // Dynamic color
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color, // Dynamic color
                                    fontSize:
                                        fontSizeSmall, // Responsive font size
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _addSubtask(taskProvider);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary, // Dynamic color
                                    fontSize:
                                        fontSizeMedium, // Responsive font size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary, // Dynamic color
                        foregroundColor: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color, // Dynamic color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadius), // Responsive border radius
                        ),
                      ),
                      child: Text(
                        "Add Subtask",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color, // Dynamic color
                          fontSize: fontSizeMedium, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: basePadding / 2), // Responsive spacing
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: basePadding), // Responsive padding
                  color: Theme.of(context)
                      .bottomAppBarTheme
                      .color, // Dynamic color
                  child: SizedBox(
                    width: double.infinity,
                    height: basePadding * 2, // Responsive height
                    child: ElevatedButton(
                      onPressed: () => taskProvider.deleteTask(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              borderRadius), // Responsive border radius
                        ),
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: Text(
                        "Delete Task",
                        style: TextStyle(
                            fontSize: fontSizeMedium), // Responsive font size
                      ),
                    ),
                  ),
                ),
                SizedBox(height: basePadding), // Responsive spacing
              ],
            )
          : Container(
              padding: EdgeInsets.all(basePadding), // Responsive padding
              color: Theme.of(context).bottomAppBarTheme.color, // Dynamic color
              child: SizedBox(
                width: double.infinity,
                height: basePadding * 2, // Responsive height
                child: ElevatedButton(
                  onPressed: () => taskProvider.deleteTask(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Responsive border radius
                    ),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: Text(
                    "Delete Task",
                    style: TextStyle(
                        fontSize: fontSizeMedium), // Responsive font size
                  ),
                ),
              ),
            ),
    );
  }
}
