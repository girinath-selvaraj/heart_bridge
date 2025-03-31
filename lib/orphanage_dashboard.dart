import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text("Orphanage Name", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.post_add),
                    title: Text("Create Post"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Donation History"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Profile Settings"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text("Bank Accounts"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.child_care),
                    title: Text("Children Management"),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dashboard Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardCard('Children', 'children', Colors.blue),
                _buildDashboardCard('Stocks', 'stocks', Colors.green),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardCard('Donations', 'donations', Colors.purple),
                _buildDashboardCard('Expenses', 'expenses', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String collectionName, Color color) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _dashboardCard(title, 'Loading...', color);
        }

        int count = snapshot.data!.docs.length;
        return _dashboardCard(title, count.toString(), color);
      },
    );
  }

  Widget _dashboardCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}