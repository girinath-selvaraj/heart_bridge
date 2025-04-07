import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatefulWidget {
  final String orphanageName;

  CreatePostPage({required this.orphanageName});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String address = '';
  File? _selectedImage;
  List<String> selectedTags = [];
  bool _isUploading = false;

  final List<String> availableTags = ['Urgent', 'Food', 'Education', 'Medical'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = Uuid().v4();
      final ref = FirebaseStorage.instance.ref().child('post_images/$fileName.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
      if (imageUrl == null) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image upload failed')));
        return;
      }
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'timestamp': Timestamp.now(),
      'orphanageName': widget.orphanageName,
      'address': address,
      'tags': selectedTags,
    });

    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created successfully!')));
    Navigator.pop(context);
  }

  Widget buildTagChips() {
    return Wrap(
      spacing: 8.0,
      children: availableTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedTags.add(tag);
              } else {
                selectedTags.remove(tag);
              }
            });
          },
          selectedColor: Colors.purple.shade200,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: _isUploading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (val) => address = val,
                validator: (val) => val!.isEmpty ? 'Enter an address' : null,
              ),
              SizedBox(height: 16),
              Text('Select Tags:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              buildTagChips(),
              SizedBox(height: 16),
              Text('Select Image:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : Text('No image selected'),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Choose Image'),
                onPressed: _pickImage,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
