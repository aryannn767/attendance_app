import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String rfidUid = '';
  String role = 'student';

  void _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      UserModel? user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
        rfidUid: rfidUid,
      );

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
          SnackBar(content: Text('Registration Failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
                onChanged: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Password too short' : null,
                onChanged: (value) => password = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'RFID UID'),
                validator: (value) => value!.isEmpty ? 'Enter RFID UID' : null,
                onChanged: (value) => rfidUid = value,
              ),
              DropdownButtonFormField<String>(
                value: role,
                decoration: InputDecoration(labelText: 'Role'),
                items: ['student', 'teacher']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role[0].toUpperCase() + role.substring(1)),
                ))
                    .toList(),
                onChanged: (value) => role = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRegistration,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}