import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_post_page.dart';
import 'login_screen_orphanage.dart';
import 'donation_history_page.dart';
import 'profile_settings_page.dart';
import 'bank_accounts_page.dart';
import 'children_management_page.dart';
import 'food_stocks_page.dart';
import 'donation_history_page.dart';
import 'expenses_page.dart';

class OrphanageDashboard extends StatefulWidget {
  @override
  _OrphanageDashboardState createState() => _OrphanageDashboardState();
}

class _OrphanageDashboardState extends State<OrphanageDashboard> {
  String orphanageName = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchOrphanageName();
  }

  Future<void> fetchOrphanageName() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    if (userId.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          orphanageName = snapshot.docs.first['orphanageName'] ?? '';
        });
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreenOrphanage()),
    );
  }

  Widget buildStatCard(String title, AsyncSnapshot<int> snapshot) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : Text('${snapshot.data}', style: TextStyle(fontSize: 24, color: Colors.purple.shade700)),
          ],
        ),
      ),
    );
  }

  Stream<int> getStatStream(String collection, {String? field}) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('orphanageId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Dashboard'),
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
                  Text(orphanageName, style: TextStyle(color: Colors.white, fontSize: 20)),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePostPage(orphanageName: orphanageName)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Donation History"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => DonationHistoryPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Profile Settings"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileSettingsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text("Bank Accounts"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BankAccountsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.child_care),
                    title: Text("Children Management"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChildrenManagementPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.food_bank),
                    title: Text("Food Stocks"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodStocksPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.volunteer_activism),
                    title: Text("Donations"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => DonationHistoryPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.money_off),
                    title: Text("Expenses"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ExpensesPage()));
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: userId.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Welcome, $orphanageName', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StreamBuilder<int>(
                  stream: getStatStream('donations'),
                  builder: (context, snapshot) => buildStatCard("Donations", snapshot),
                ),
                StreamBuilder<int>(
                  stream: getStatStream('expenses'),
                  builder: (context, snapshot) => buildStatCard("Expenses", snapshot),
                ),
                StreamBuilder<int>(
                  stream: getStatStream('children'),
                  builder: (context, snapshot) => buildStatCard("Children", snapshot),
                ),
                StreamBuilder<int>(
                  stream: getStatStream('food_stocks'),
                  builder: (context, snapshot) => buildStatCard("Food Stocks", snapshot),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
