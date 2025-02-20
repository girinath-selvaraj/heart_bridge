import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_bridge/history_page.dart';
import 'package:heart_bridge/login_screen_donor.dart';

class FeedsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donor Feeds"),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual image
                  ),
                  SizedBox(height: 10),
                  Text("Donor Name", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Donated History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreenDonor()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: ListView.builder(
          itemCount: 5, // Example count, replace with actual data count
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual profile image
                        ),
                        SizedBox(width: 10.w),
                        Text("Orphanage Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/img1.jpg', // Replace with actual post image
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "We need your support! Help us provide food and education to orphaned children. Every contribution makes a difference.❤️",
                          style: TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Implement location fetching here
                          },
                          icon: Icon(Icons.location_on, color: Colors.white),
                          label: Text("View Location",style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Implement donate now action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              ),
                              child: Text("Donate Now", style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Implement know about trust action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              ),
                              child: Text("Know About Trust", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
