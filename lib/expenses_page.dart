// expenses_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _description;
  double? _amount;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _addExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('expenses').add({
        'orphanageId': userId,
        'description': _description,
        'amount': _amount,
        'timestamp': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense added successfully')),
      );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value,
                    validator: (value) => value == null || value.isEmpty ? 'Enter a description' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _amount = double.tryParse(value ?? ''),
                    validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid amount' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addExpense,
                    child: Text('Add Expense'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('expenses')
                    .where('orphanageId', isEqualTo: userId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final expenses = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        title: Text(expense['description'] ?? ''),
                        subtitle: Text('₹${expense['amount']?.toStringAsFixed(2) ?? ''}'),
                        trailing: Text((expense['timestamp'] as Timestamp).toDate().toLocal().toString().split(' ')[0]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
