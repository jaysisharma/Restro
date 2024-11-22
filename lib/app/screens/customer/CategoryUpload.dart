import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CategoryUploadPage extends StatefulWidget {
  @override
  _CategoryUploadPageState createState() => _CategoryUploadPageState();
}

class _CategoryUploadPageState extends State<CategoryUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  bool _isUploading = false;

  // Define custom colors
  final Color _primaryColor = Color(0xFFA93036); // Burgundy
  final Color _backgroundColor = Color(0xFFF6E1B3); // Light Beige

  // Fetch category list from Firestore
  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      return {
        'name': doc['name'],
        'image': doc['image'],
      };
    }).toList();
  }

  // Upload the selected image to Cloudinary
  Future<String?> _uploadImageToCloudinary(File image) async {
    final cloudName = 'dyugb2jp8';
    final uploadPreset = 'Restro Menu';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final result = json.decode(responseData.body);
      return result['secure_url'];
    }
    return null;
  }

  // Upload category data (name and image URL) to Firestore
  Future<void> _uploadCategoryToFirestore(String name, String imageUrl) async {
    try {
      setState(() {
        _isUploading = true;
      });

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference categoriesRef = firestore.collection('categories');

      // Add the category to Firestore
      await categoriesRef.add({
        'name': name,
        'image': imageUrl,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category "$name" uploaded successfully!')),
      );

      // Clear fields after successful upload
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading category: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    // Directly pick image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Clear the fields after a successful upload
  void _clearFields() {
    _nameController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text('Upload Category'),
        backgroundColor: _primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField for category name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(color: _primaryColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Button to select image
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: _image == null
                    ? Center(child: Icon(Icons.add_a_photo, size: 40))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Show loading indicator while uploading
            if (_isUploading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              GestureDetector(
                onTap: () async {
                  final name = _nameController.text.trim();
                  if (name.isEmpty || _image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  // Upload image to Cloudinary
                  final imageUrl = await _uploadImageToCloudinary(_image!);
                  if (imageUrl != null) {
                    // Upload category to Firestore
                    await _uploadCategoryToFirestore(name, imageUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to upload image')),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Category',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Categories section title
            Text(
              'Categories',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Fetch and display categories
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final categories = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: category['image'] != null
                              ? Image.network(category['image'], width: 50, height: 50, fit: BoxFit.cover)
                              : Icon(Icons.category, color: _primaryColor),
                          title: Text(category['name'], style: TextStyle(color: _primaryColor)),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
