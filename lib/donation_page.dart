import 'package:flutter/material.dart';

class DonationPage extends StatelessWidget {
  final String postId;

  DonationPage({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donate")),
      body: Center(
        child: Text("Donation Page for Post ID: $postId"),
      ),
    );
  }
}
