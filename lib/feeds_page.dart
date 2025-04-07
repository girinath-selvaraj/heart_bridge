import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'donation_page.dart'; // Create this page
import 'second_screen.dart';

class DonorFeedsPage extends StatefulWidget {
  @override
  _DonorFeedsPageState createState() => _DonorFeedsPageState();
}

class _DonorFeedsPageState extends State<DonorFeedsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _searchAddress = '';

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SecondScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Needs'),
        backgroundColor: Colors.purple.shade700,
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter by Address',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchAddress = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading posts'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No posts available.'));
                }

                final posts = snapshot.data!.docs.where((post) {
                  final address = post['address']?.toString().toLowerCase() ?? '';
                  return address.contains(_searchAddress);
                }).toList();

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return _buildPostCard(post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(DocumentSnapshot post) {
    final tags = List<String>.from(post['tags'] ?? []);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['title'] ?? 'No Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(post['description'] ?? 'No Description'),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.purple.shade100,
                  labelStyle: TextStyle(color: Colors.purple.shade800),
                );
              }).toList(),
            ),
            if (post['imageUrl'] != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image.network(post['imageUrl']),
              ),
            SizedBox(height: 8),
            Text('Address: ${post['address'] ?? "N/A"}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posted by: ${post['orphanageName']}'),
                Text('${post['timestamp'].toDate()}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DonationPage(postId: post.id)),
                    );
                  },
                  icon: Icon(Icons.volunteer_activism),
                  label: Text('Donate'),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Share.share(
                      'Check this need from ${post['orphanageName']}:\n${post['title']} - ${post['description']}',
                    );
                  },
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final user = _auth.currentUser;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Donor'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (user?.displayName?.isNotEmpty == true)
                    ? user!.displayName!.substring(0, 1).toUpperCase()
                    : '?',
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Donation History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
