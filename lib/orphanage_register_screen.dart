import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied || await Permission.videos.isDenied) {
        await Permission.photos.request();
        await Permission.videos.request();
      }
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.photos.isPermanentlyDenied ||
          await Permission.videos.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<void> _pickDocument() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedDocument = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document Selected: ${_selectedDocument!.path.split('/').last}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No document selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick document: $e')),
      );
    }
  }

  Future<void> _registerOrphanage() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDocument == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload the required document.')),
        );
      } else {
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
          'status': 'Pending', // Status for verification
          'createdAt': FieldValue.serverTimestamp(),
        };

        try {
          final docRef = await FirebaseFirestore.instance.collection('orphanages').add(orphanageData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Orphanage registered successfully!')),
          );

          // Navigate to Verification Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrphanageVerificationScreen(orphanageId: docRef.id)),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_nameController, 'Orphanage Name'),
                _buildTextField(_emailController, 'Email'),
                _buildTextField(_passwordController, 'Password', isPassword: true),
                _buildTextField(_phoneController, 'Phone Number'),
                _buildTextField(_addressController, 'Address'),

                SizedBox(height: 20.h),
                Text('Bank Details', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                _buildTextField(_accountNumberController, 'Account Number'),
                _buildTextField(_ifscController, 'IFSC Code'),
                _buildTextField(_accountNameController, 'Account Holder Name'),
                _buildTextField(_bankMobileController, 'Bank Registered Mobile Number'),
                _buildTextField(_bankNameController, 'Bank Name'),

                SizedBox(height: 20.h),
                const Text('Upload Registration Document:'),
                SizedBox(height: 10.h),
                _selectedDocument == null
                    ? const Text('No document selected.')
                    : Text('Document Selected: ${_selectedDocument!.path.split('/').last}'),
                ElevatedButton(
                  onPressed: _pickDocument,
                  child: const Text('Select Document'),
                ),

                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    onPressed: _registerOrphanage,
                    child: const Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                    ),
                  ),
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        obscureText: isPassword,
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}