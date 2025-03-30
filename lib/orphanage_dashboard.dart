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
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.purple.shade700),
                accountName: Text("Orphanage Name", style: TextStyle(fontSize: 18)),
                accountEmail: Text("orphanage@example.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Home"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
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
                        leading: Icon(Icons.account_balance),
                        title: Text("Bank Accounts"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.child_care),
                        title: Text("Children / aged children"),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.inventory_2),
                        title: Text("Available Stocks"),
                        subtitle: Text("Food: 500 kg, Clothes: 200 items"),
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text("Available Funds"),
                        subtitle: Text("₹1,50,000"),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
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
      ),
      body: Center(
        child: Text(
          "Welcome to Orphanage Dashboard",
          style: TextStyle(fontSize: 20, color: Colors.purple.shade700),
        ),
      ),
    );
  }
}
