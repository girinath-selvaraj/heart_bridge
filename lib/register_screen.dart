import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'feeds_page.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isEmailSent = false;
  String errorMessage = '';

  Future<void> _register() async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Store user data in Firestore using UID as the document ID
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userId': uid,
        'name': _nameController.text.trim(),
        'dob': _dobController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'location': _locationController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      print("User data stored successfully!");

      setState(() {
        _isEmailSent = true;
      });

    } catch (e) {
      print("Error storing user data: $e");
      setState(() {
        errorMessage = e.toString();
      });
    }
  }




  Future<void> _checkEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FeedsPage()),
      );
    } else {
      setState(() {
        errorMessage = "Email not verified. Please check your inbox.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.purple.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text("Full Name", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your full name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text("Date of Birth", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "DD/MM/YYYY",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 10.h),
                Text("Mobile Number", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter mobile number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10.h),
                Text("Location", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text("Email", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),
                Text("Password", style: TextStyle(color: Colors.white)),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10.h),
                _isEmailSent
                    ? Column(
                  children: [
                    Text("A verification email has been sent. Please check your inbox.",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: _checkEmailVerified,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                      ),
                      child: Text("I've Verified My Email", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                  ),
                  child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}