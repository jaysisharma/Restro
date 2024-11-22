import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:restro/utils/theme.dart';

import 'UserDetailScreen.dart';

class AdminUserManagementScreen extends StatefulWidget {
  @override
  _AdminUserManagementScreenState createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final _formKey = GlobalKey<FormState>(); // Added FormKey for validation
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _originalEmailController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String selectedRole = 'manager';
  String filteredRole = 'all'; // Added filter variable
  bool isLoading = false;
  List<String> roles = ['admin', 'manager', 'staff', 'all'];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  String generateUniqueEmail(String firstName) {
    final random = Random();
    int randomNumber = 100 + random.nextInt(900);
    String cleanedFirstName = firstName.replaceAll(' ', '').toLowerCase();
    return '$cleanedFirstName$randomNumber@restaurant.com';
  }

  String generateUniquePassword() {
    const length = 8;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%&*';
    final random = Random();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> addUser(String firstName, String originalEmail, String role,
      String phone, BuildContext context) async {
    final existingUser = await FirebaseFirestore.instance
        .collection('users')
        .where('originalEmail', isEqualTo: originalEmail)
        .get();

    if (existingUser.docs.isNotEmpty) {
      _showErrorDialog(context, 'Original email already exists.');
      return;
    }

    String uniqueEmail = generateUniqueEmail(firstName);
    var existingUniqueEmail = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueEmail', isEqualTo: uniqueEmail)
        .get();

    while (existingUniqueEmail.docs.isNotEmpty) {
      uniqueEmail = generateUniqueEmail(firstName);
      existingUniqueEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('uniqueEmail', isEqualTo: uniqueEmail)
          .get();
    }

    String uniquePassword = generateUniquePassword();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: uniqueEmail,
        password: uniquePassword,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'id': userId,
        'name': firstName,
        'originalEmail': originalEmail,
        'uniqueEmail': uniqueEmail,
        'password': uniquePassword,
        'role': role,
        'phone': phone,
      });

      await sendEmail(originalEmail, uniqueEmail, uniquePassword, context);

      _clearFields();
      _showSuccessDialog(context);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message ?? 'Failed to create user');
    }
  }

  Future<void> sendEmail(String recipientEmail, String uniqueEmail,
      String password, BuildContext context) async {
    final smtpServer = gmail('jsharma852@rku.ac.in',
        'oqynqsywqdthmvyc'); // Use your actual credentials

    final message = Message()
      ..from = Address('shrutee732@gmail.com', 'Restaurant Admin')
      ..recipients.add(recipientEmail)
      ..subject = 'Your Restaurant Admin Account Credentials'
      ..text = 'Hello,\n\n'
          'Here are your login credentials for the restaurant admin system:\n'
          'Unique Email: $uniqueEmail\n'
          'Password: $password\n\n'
          'Please keep this information secure.\n\n'
          'Best regards,\n'
          'Restaurant Admin Team';

    try {
      await send(message, smtpServer);
    } catch (e) {
      _showErrorDialog(context, 'Failed to send email: $e');
    }
  }

  void _clearFields() {
    _firstNameController.clear();
    _originalEmailController.clear();
    _phoneController.clear();
    setState(() {
      selectedRole = roles[0]; // Reset selected role to default
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success', style: TextStyle(color: Colors.green)),
          content: Text('Credentials email sent successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Validate email format
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter email';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate non-empty fields
  String? _validateNonEmpty(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isEmail,
      {IconData? icon} // Ensure this is an optional parameter
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Icon(icon)
              : null, // Ensure the icon is passed and rendered
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required'; // Custom error message for required field
          }
          if (isEmail && !RegExp(r'\w+@\w+\.\w+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null; // Return null if no validation errors
        },
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        items: roles.map((role) {
          return DropdownMenuItem(value: role, child: Text(role));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Role',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButton<String>(
        value: filteredRole,
        items: ['all', 'admin', 'manager', 'staff'].map((role) {
          return DropdownMenuItem(value: role, child: Text(role));
        }).toList(),
        onChanged: (value) {
          setState(() {
            filteredRole = value!;
          });
        },
        hint: Text('Filter by Role'),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: 'Search Users',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isNotEqualTo: 'customer') // Exclude customers
            .where('role',
                isEqualTo: filteredRole == 'all'
                    ? null
                    : filteredRole) // Apply filter based on selection
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found."));
          }

          List<DocumentSnapshot> filteredDocs =
              snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            String name = data['name'] ?? '';
            String email = data['uniqueEmail'] ?? '';
            return name.toLowerCase().contains(searchQuery) ||
                email.toLowerCase().contains(searchQuery);
          }).toList();

          return ListView(
            children: filteredDocs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? 'No Name'),
                subtitle:
                    Text('${data['role'] ?? 'Role'} | ${data['uniqueEmail']}'),
                onTap: () {
                  // Navigate to user details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        userId: doc.id,
                        role: data['role'],
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(doc.id)
                        .delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Management'),

          backgroundColor: AppColors.primary, // Use the same primary color
          foregroundColor: Colors.white, // Set foreground color to white
          centerTitle: true, // Center the title
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Add User'),
              Tab(text: 'User List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add User',
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              _firstNameController,
                              icon: Icons.person,
                              'Full Name',
                              false),
                          _buildTextField(
                            _phoneController,
                            'Phone Number',
                            false,
                            icon: Icons.phone,
                          ),
                          _buildTextField(
                            _originalEmailController,
                            'Original Email',
                            true,
                            icon: Icons.email,
                          ),
                          _buildRoleDropdown(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  addUser(
                                    _firstNameController.text,
                                    _originalEmailController.text,
                                    selectedRole,
                                    _phoneController.text,
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromARGB(255, 192, 50, 57),
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Add User',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildFilterDropdown(),
                    ],
                  ),
                  _buildSearchField(), // Added search field
                  _buildUserList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
