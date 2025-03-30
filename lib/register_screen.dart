// register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'email_verification_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  String errorMessage = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String generateUserId(String name, String mobile) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String cleanName = name.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return '\${cleanName}_\${mobile}_\${timestamp}';
  }

  Future<void> _register() async {
    if (_selectedDate == null) {
      setState(() {
        errorMessage = 'Please select your Date of Birth.';
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      String structuredUserId = generateUserId(_nameController.text.trim(), _mobileController.text.trim());

      // Store all user data in one document
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userId': structuredUserId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _selectedDate?.toIso8601String(),
        'mobile': _mobileController.text.trim(),
        'location': _locationController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      await userCredential.user?.sendEmailVerification();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField('Full Name', _nameController, Icons.person),
                  _buildTextField('Email', _emailController, Icons.email),
                  _buildTextField('Password', _passwordController, Icons.lock, isPassword: true),
                  _buildTextField('Mobile', _mobileController, Icons.phone, keyboardType: TextInputType.phone),
                  _buildTextField('Location', _locationController, Icons.location_on),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select Date of Birth'
                                : 'DOB: \${_selectedDate!.toLocal()}'.split(' ')[0],
                            style: TextStyle(color: Colors.black54),
                          ),
                          Icon(Icons.calendar_today, color: Colors.blue.shade700),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  SizedBox(height: 20.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false, TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
