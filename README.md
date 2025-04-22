## DayTask

A simple personal task tracking app built with Flutter and Supabase. The app allows users to log in, manage tasks (add, delete, mark as completed), and view their tasks on a dashboard. It features responsive UI, clean state management, and basic animations.

# Folder structure:

lib/
|
|--main.dart
|--navigation.dart
|--splash_screen.dart
|--app/
|   |---theme_provider.dart
|--auth/
|   |---auth_service.dart
|   |---login_screen.dart
|   |---signup_screen.dart
|--dashboard/
|   |---dashboard_screen.dart
|   |---ongoing_project_card.dart
|   |---task_completed_card.dart
|--profile/
|   |---profile_screen.dart
|   |---settings_screen.dart
|--services/
|   |---supabase_service.dart
|--task/
|   |---add_task.dart
|   |---task_details.dart
|--utils/
|   |---task_provider.dart

# Hot Reload V/S Hot Restart

Hot Reload : Keeps the app running and applies changes instantly (faster).

Hot Restart : Resets the app and applies changes (slower but handles more complex updates).
