import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class ManageMenuScreen extends StatefulWidget {
  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isLoading = false;
  String selectedCategory = 'Veg';
  String selectedType = 'Starter';

  final List<String> categories = ['Veg', 'Non-Veg'];
  final List<String> types = ['Starter', 'Meal', 'Dessert'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Menu", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA93036), // Burgundy
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: [
            const Tab(text: 'Add Menu Item'),
            const Tab(text: 'Menu List'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuForm(),
          _buildMenuList(),
        ],
      ),
    );
  }

  Widget _buildMenuForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Menu Item",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA93036)),
            ),
            const SizedBox(height: 10),
            _buildTextFormField(_itemNameController, "Item Name"),
            const SizedBox(height: 10),
            _buildTextFormField(_itemPriceController, "Price",
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextFormField(_itemDescriptionController, "Description"),
            const SizedBox(height: 10),
            _buildDropdown("Category", categories, selectedCategory, (value) {
              setState(() {
                selectedCategory = value!;
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown("Type", types, selectedType, (value) {
              setState(() {
                selectedType = value!;
              });
            }),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(_selectedImage!,
                    height: 100, width: 100, fit: BoxFit.cover),
              ),
            const SizedBox(height: 10),
            _buildFlatButton("Select Image", _pickImage),
            const SizedBox(height: 10),
            _buildFlatButton("Add Menu Item", _addMenuItem),
            // if (isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFA93036)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFA93036)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFA93036)),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFA93036)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFlatButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed, // Disable button during loading
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : const Color(0xFFA93036),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 6, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect(); // Show shimmer effect
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No menu items found"));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var menuItem = doc.data() as Map<String, dynamic>;
            return ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(menuItem['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                "Price: \$${menuItem['price']} | Description: ${menuItem['description']} | "
                "Category: ${menuItem['category']} | Type: ${menuItem['type']}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder:
                      'assets/images/placeholder.jpg', // Add your placeholder image here
                  image: menuItem['imageUrl'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFFA93036)),
                    onPressed: () => _editMenuItem(doc.id, menuItem, context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteMenuItem(doc.id),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addMenuItem() async {
    if (_itemNameController.text.isEmpty ||
        _itemPriceController.text.isEmpty ||
        _itemDescriptionController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl = await _uploadImageToCloudinary(_selectedImage!);

    await FirebaseFirestore.instance.collection('menu').add({
      'name': _itemNameController.text,
      'price': double.tryParse(_itemPriceController.text) ?? 0.0,
      'description': _itemDescriptionController.text,
      'category': selectedCategory,
      'type': selectedType,
      'imageUrl': imageUrl,
    });

    _clearFields();
    setState(() {
      isLoading = false;
    });

    Get.snackbar(
      "Success",
      "Menu Added Successfully",
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      backgroundColor: Colors.green, // Background color of the snackbar
      colorText: Colors.white, // Text color
      duration:
          const Duration(seconds: 2), // Duration for which snackbar will be visible
      margin: const EdgeInsets.all(10), // Margin around the snackbar
      borderRadius: 10, // Rounded corners
    );
  }

  Future<String?> _uploadImageToCloudinary(File image) async {
    final cloudName = 'dyugb2jp8';
    final uploadPreset = 'Restro Menu';

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
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

  void _editMenuItem(
      String id, Map<String, dynamic> menuItem, BuildContext context) {
    _itemNameController.text = menuItem['name'];
    _itemPriceController.text = menuItem['price'].toString();
    _itemDescriptionController.text = menuItem['description'];
    selectedCategory = menuItem['category'];
    selectedType = menuItem['type'];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Menu Item"),
          content: _buildMenuForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearFields();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('menu')
                    .doc(id)
                    .update({
                  'name': _itemNameController.text,
                  'price': double.tryParse(_itemPriceController.text) ?? 0.0,
                  'description': _itemDescriptionController.text,
                  'category': selectedCategory,
                  'type': selectedType,
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu item updated successfully')),
                );

                _clearFields();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteMenuItem(String id) async {
    await FirebaseFirestore.instance.collection('menu').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu item deleted successfully')),
    );
  }

  void _clearFields() {
    _itemNameController.clear();
    _itemPriceController.clear();
    _itemDescriptionController.clear();
    selectedCategory = 'Veg';
    selectedType = 'Starter';
    _selectedImage = null;
  }
}
