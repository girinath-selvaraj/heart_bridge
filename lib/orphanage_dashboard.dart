import 'package:flutter/material.dart';
import 'login_screen_orphanage.dart';

class OrphanageDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orphanage Dashboard"),
        backgroundColor: Colors.purple.shade700,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple.shade700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Ensure this file exists
                  ),
                  SizedBox(height: 10),
                  Text("Orphanage Name", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreenOrphanage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Welcome to Orphanage Dashboard", style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
