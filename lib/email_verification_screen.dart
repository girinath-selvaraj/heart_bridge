import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_bridge/login_screen_donor.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified! Redirecting to login...')),
      );

      // Navigate to LoginScreenDonor
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenDonor()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not verified. Please check your inbox.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('A verification email has been sent to your email address.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkEmailVerified,
              child: const Text("I've Verified My Email"),
            ),
          ],
        ),
      ),
    );
  }
}
