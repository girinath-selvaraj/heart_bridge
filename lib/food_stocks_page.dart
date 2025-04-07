// food_stocks_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodStocksPage extends StatefulWidget {
  @override
  _FoodStocksPageState createState() => _FoodStocksPageState();
}

class _FoodStocksPageState extends State<FoodStocksPage> {
  final _formKey = GlobalKey<FormState>();
  String? _item;
  int? _quantity;
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

  Future<void> _addStock() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('food_stocks').add({
        'orphanageId': userId,
        'item': _item,
        'quantity': _quantity,
        'timestamp': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stock added successfully')));
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Stocks'),
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
                    decoration: InputDecoration(labelText: 'Item'),
                    onSaved: (value) => _item = value,
                    validator: (value) => value == null || value.isEmpty ? 'Enter an item' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _quantity = int.tryParse(value ?? ''),
                    validator: (value) => value == null || int.tryParse(value) == null ? 'Enter a valid quantity' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addStock,
                    child: Text('Add Stock'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('food_stocks')
                    .where('orphanageId', isEqualTo: userId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final stocks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      final stock = stocks[index];
                      return ListTile(
                        title: Text(stock['item'] ?? ''),
                        subtitle: Text('Quantity: ${stock['quantity']}'),
                        trailing: Text((stock['timestamp'] as Timestamp).toDate().toLocal().toString().split(' ')[0]),
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
