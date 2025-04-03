import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'donor_register_screen.dart';
import 'orphanage_register_screen.dart';
import 'login_screen_donor.dart';
import 'login_screen_orphanage.dart';

class SecondScreen extends StatelessWidget {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to HeartBridge",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),

                /// **Login Buttons**
                _buildButton(
                  context,
                  text: "Login as Donor",
                  screen: LoginScreenDonor(),
                ),
                SizedBox(height: 20.h),
                _buildButton(
                  context,
                  text: "Login as Orphanage",
                  screen: LoginScreenOrphanage(),
                ),
                SizedBox(height: 30.h),

                /// **Registration Buttons**
                Text(
                  "New User? Register Below",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 20.h),

                _buildButton(
                  context,
                  text: "Register as Donor",
                  screen: DonorRegisterScreen(),
                ),
                SizedBox(height: 20.h),
                _buildButton(
                  context,
                  text: "Register as Orphanage",
                  screen: OrphanageRegisterScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **Reusable Button Widget**
  Widget _buildButton(BuildContext context, {required String text, required Widget screen}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
      ),
      child: Text(text, style: TextStyle(color: Colors.purple.shade700)),
    );
  }
}
