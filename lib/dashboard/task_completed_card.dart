import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/task_provider.dart';
import '../app/theme_provider.dart'; // Import your ThemeProvider

class TaskCompletedCard extends StatelessWidget {
  final int taskId;
  final VoidCallback onTap;

  const TaskCompletedCard({
    super.key,
    required this.taskId,
    required this.onTap,
  });

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
    final double cardWidth = screenWidth * 0.5; // 40% of screen width
    final double cardHeight = screenHeight * 0.3; // 30% of screen height

    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Fetch the task details based on taskId
    final task = taskProvider.completedTasks.firstWhere(
      (t) => t['id'] == taskId,
      orElse: () => {},
    );

    if (task.isEmpty) {
      return Center(
        child: Text(
          "Task not found",
          style: TextStyle(fontSize: fontSizeMedium, color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth, // Responsive card width
        height: cardHeight, // Responsive card height
        margin: EdgeInsets.only(right: basePadding), // Responsive margin
        padding: EdgeInsets.all(basePadding), // Responsive padding
        decoration: BoxDecoration(
          color: Theme.of(context).listTileTheme.tileColor, // Dynamic tile color
          borderRadius: BorderRadius.circular(borderRadius), // Responsive border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color, // Dynamic text color
                fontFamily: "PilatExtended",
                fontSize: fontSizeLarge, // Responsive font size
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: basePadding), // Responsive spacing
            // Due Date
            Text(
              "Due: ${task['due_datetime']?.toString().split('T').first ?? 'N/A'}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color, // Dynamic text color
                fontSize: fontSizeSmall, // Responsive font size
              ),
            ),
            const Spacer(),
            // Progress Text
            Text(
              "Completed ${(task['progressPercent'] ?? 100).toInt()}%",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color, // Dynamic text color
                fontSize: fontSizeMedium, // Responsive font size
              ),
            ),
            SizedBox(height: basePadding / 2), // Responsive spacing
            // Progress Indicator
            LinearProgressIndicator(
              value: (task['progressPercent'] ?? 100) / 100,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.3), // Dynamic background color
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary, // Dynamic progress color
              ),
            ),
          ],
        ),
      ),
    );
  }
}