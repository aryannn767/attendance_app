import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/theme.dart';
import 'screens/student/student_home_screen.dart';
import 'screens/teacher/teacher_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance App',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const StudentHomeScreen()),
              child: const Text('Login as Student'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const TeacherHomeScreen()),
              child: const Text('Login as Teacher'),
            ),
          ],
        ),
      ),
    );
  }
}
