import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donated History"),
        backgroundColor: Colors.purple.shade700,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 5, // Example count, replace with actual data count
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(Icons.volunteer_activism, color: Colors.purple.shade700),
              title: Text("Donation #$index"),
              subtitle: Text("Donated to Orphanage Name\nDate: 2024-02-10"),
            ),
          );
        },
      ),
    );
  }
}
