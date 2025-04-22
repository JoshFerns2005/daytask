# DayTask

**DayTask** is a simple personal task tracking app built with Flutter and Supabase. It allows users to sign up, log in, manage tasks (add, delete, mark as completed), and view their tasks on a dashboard. The app features responsive UI, clean state management using Provider, and smooth animations.

---

##  Features

-  Email/password authentication (Supabase)
-  Add, edit, delete tasks
-  Mark tasks as completed
-  Dashboard for ongoing and completed tasks
-  Profile & settings screen
-  Light & dark theme toggle
-  Responsive layout
-  Clean folder structure
-  Used Provider for State Management

---

## Folder Structure

```plaintext
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
```
## Getting Started
1. Clone the Repository
```
git clone https://github.com/your-username/daytask.git
cd daytask
```
3. Set Up Flutter Project
If you haven’t created a Flutter project yet:

Press Ctrl + Shift + P in VS Code

Select Flutter: New Project

Choose a location and project name

Replace the lib/ folder contents with the structure above

Then run:
```
flutter pub get
```
# Set Up Supabase
1. Create a Supabase Project
Go to https://supabase.com

Sign in and create a new project

Set a project name, password, and database region

2. Get Your Supabase URL & Anon Key
In your Supabase dashboard:

Go to Project Settings → API

Copy the Project URL

Copy the anon public API key

3. Enable Auth
Go to Authentication → Settings

Enable Email sign-in

# Running the App
Run the app with:
```
flutter run
```

## Hot Reload vs Hot Restart
```
Hot Reload :	Applies code changes without restarting the app (faster)
Hot Restart :	Restarts the app and applies deeper changes (slower)
```

