import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/task_provider.dart';
import '../app/theme_provider.dart'; // Import your ThemeProvider

class OngoingProjectCard extends StatelessWidget {
  final int taskId;
  final VoidCallback onTap;

  const OngoingProjectCard({
    super.key,
    required this.taskId,
    required this.onTap,
  });

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoDate;
    }
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
    final double cardHeight = screenHeight * 0.18; // 18% of screen height
    final double progressSize = screenWidth * 0.12; // 12% of screen width

    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Fetch the task details based on taskId
    final task = taskProvider.ongoingProjects.firstWhere(
      (project) => project['id'] == taskId,
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

    final formattedDate = _formatDate(task['due_datetime']?.toString() ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight, // Responsive card height
        margin: EdgeInsets.only(bottom: basePadding), // Responsive margin
        padding: EdgeInsets.all(basePadding), // Responsive padding
        decoration: BoxDecoration(
          color: Theme.of(context).listTileTheme.tileColor, // Dynamic tile color
          borderRadius: BorderRadius.circular(borderRadius), // Responsive border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Section: Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
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
                ),
              ],
            ),

            // Bottom Section: Due Date and Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Due on:",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color, // Dynamic text color
                        fontSize: fontSizeSmall, // Responsive font size
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color, // Dynamic text color
                        fontSize: fontSizeMedium, // Responsive font size
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: progressSize, // Responsive progress size
                      height: progressSize, // Responsive progress size
                      child: CircularProgressIndicator(
                        value: task['percentage'] / 100,
                        strokeWidth: screenWidth * 0.01, // Responsive stroke width
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.secondary, // Use secondary color
                        ),
                      ),
                    ),
                    Text(
                      "${task['percentage'].toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color, // Dynamic text color
                        fontSize: fontSizeSmall, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}