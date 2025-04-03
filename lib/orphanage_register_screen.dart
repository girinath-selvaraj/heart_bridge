// Orphanage Registration Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'orphanage_verification_screen.dart';

class OrphanageRegisterScreen extends StatefulWidget {
  @override
  _OrphanageRegisterScreenState createState() => _OrphanageRegisterScreenState();
}

class _OrphanageRegisterScreenState extends State<OrphanageRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankMobileController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  File? _selectedDocument;

  Future<void> _pickDocument() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedDocument = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick document: $e')));
    }
  }

  Future<void> _registerOrphanage() async {
    if (!_formKey.currentState!.validate() || _selectedDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and upload the document.')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final orphanageData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'accountNumber': _accountNumberController.text,
        'ifscCode': _ifscController.text,
        'accountName': _accountNameController.text,
        'bankMobileNumber': _bankMobileController.text,
        'bankName': _bankNameController.text,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('orphanages').doc(userCredential.user!.uid).set(orphanageData);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orphanage Registered Successfully!')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrphanageVerificationScreen(orphanageId: userCredential.user!.uid)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orphanage Registration')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'Orphanage Name'),
                _buildTextField(_emailController, 'Email'),
                _buildTextField(_passwordController, 'Password', isPassword: true),
                _buildTextField(_phoneController, 'Phone Number'),
                _buildTextField(_addressController, 'Address'),
                _buildTextField(_accountNumberController, 'Account Number'),
                _buildTextField(_ifscController, 'IFSC Code'),
                _buildTextField(_accountNameController, 'Account Holder Name'),
                _buildTextField(_bankMobileController, 'Bank Registered Mobile Number'),
                _buildTextField(_bankNameController, 'Bank Name'),

                SizedBox(height: 10.h),
                ElevatedButton(onPressed: _pickDocument, child: Text('Select Document')),
                SizedBox(height: 10.h),
                _selectedDocument == null ? Text('No document selected') : Text('Document Selected'),

                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _registerOrphanage,
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}

// Next, I will add the Orphanage Login Page after this. Let me know if you'd like to proceed!
