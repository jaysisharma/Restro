import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restro/utils/theme.dart';

class UserDetailScreen extends StatelessWidget {
  final String userId;
  final String role; // New parameter for role

  UserDetailScreen({required this.userId, required this.role});

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserDetails(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No details found.'));
        }
        final data = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('${role.capitalize()} Details'), // Dynamically set role in title
            backgroundColor: AppColors.primary, // Use the same primary color
            foregroundColor: Colors.white, // Set foreground color to white
            centerTitle: true, // Center the title
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${data['name'] ?? 'No Name Available'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // If the role is customer, show email and exclude role
                if (role == 'customer') 
                  Text(
                    'Email: ${data['email'] ?? 'No Email Available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                if (role != 'customer') 
                  Text(
                    'Email: ${data['uniqueEmail'] ?? 'No Email Available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                 if (role != 'customer') 
                  Text(
                    'Original Email: ${data['originalEmail'] ?? 'No Email Available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                // If the role is not customer, show role
                if (role != 'customer') 
                  Text(
                    'Role: ${data['role'] ?? 'No Role Available'}',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${data['phone'] ?? 'No Phone Available'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                // You can add more fields here if needed
              ],
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  // Capitalizes the first letter of a string
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}




