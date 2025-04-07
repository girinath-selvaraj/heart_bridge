import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Add this line
import 'package:shared_preferences/shared_preferences.dart';

import 'feeds_page.dart';
import 'orphanage_dashboard.dart';
import 'second_screen.dart';


class OnboardingScreen extends StatefulWidget {
  final bool isOrphanageLogin;
  OnboardingScreen({this.isOrphanageLogin = false});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  void _checkUserLoggedIn() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating loading
    final user = _auth.currentUser;

    if (user != null) {
      // Check if the user is an orphanage or donor
      final prefs = await SharedPreferences.getInstance();
      final userId = user.uid;

      // First check orphanages collection
      final orphanageSnapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('userId', isEqualTo: userId)
          .get();

      if (orphanageSnapshot.docs.isNotEmpty) {
        // Save info to prefs
        prefs.setString('userId', userId);
        prefs.setBool('isOrphanageLogin', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrphanageDashboard()),
        );
        return;
      }

      // Default to donor
      prefs.setBool('isOrphanageLogin', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DonorFeedsPage()),
      );
    } else {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/workspace.png',
                height: 250.h,
              ),
              SizedBox(height: 30.h),
              Text(
                "Heart Bridge",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.isOrphanageLogin ? "For Orphanages" : "For Donors",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
              SizedBox(height: 40.h),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text("Get Started", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
