import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      UserModel? user = await _authService.signIn(email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => user.role == 'teacher'
                ? TeacherDashboard(user: user)
                : StudentDashboard(user: user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed')),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance App')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
                onChanged: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Enter password' : null,
                onChanged: (value) => password = value,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: _navigateToRegistration,
                    child: Text('Register New Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}