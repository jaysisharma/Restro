import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:restro/utils/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:restro/app/screens/admin/CustomerList.dart';
import 'package:restro/app/screens/admin/Feedbacks.dart';
import 'package:restro/app/screens/customer/LoginScreen.dart';
import 'package:restro/app/screens/customer/UserProfileScreen.dart';
import 'package:restro/app/screens/manager/SalesPage.dart';
import 'package:restro/app/screens/admin/ManageMenuScreen.dart';

import 'CRUD.dart';

class AdminPage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fetch total sales data and today's orders
  Future<Map<String, dynamic>> fetchSalesData() async {
    double totalSalesToday = 0.0;
    double totalSalesThisMonth = 0.0;
    int ordersToday = 0; // Counter for today's orders
    final DateTime now = DateTime.now();

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Completed')
        .get();

    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data() as Map<String, dynamic>;
      final timestamp = (orderData['timestamp'] as Timestamp).toDate();
      final quantity = orderData['quantity'] ?? 0;
      final itemPrice = await fetchItemPrice(orderData['item']);
      double totalOrderPrice = itemPrice * quantity;

      // Today's Sales and Orders Count
      if (timestamp.day == now.day &&
          timestamp.month == now.month &&
          timestamp.year == now.year) {
        totalSalesToday += totalOrderPrice;
        ordersToday += 1; // Increment the counter
      }

      // Monthly Sales
      if (timestamp.month == now.month && timestamp.year == now.year) {
        totalSalesThisMonth += totalOrderPrice;
      }
    }
    return {
      'today': totalSalesToday,
      'month': totalSalesThisMonth,
      'ordersToday': ordersToday,
    };
  }

  Future<String> fetchUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        return userData?['name'] ?? 'No Name';  // Default if name is missing
      }
      return 'User not found';  // If document doesn't exist
    } catch (e) {
      return 'Error fetching name: $e';  // Handle any errors
    }
  }

  // Fetch item price
  Future<double> fetchItemPrice(String itemName) async {
    final menuSnapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('name', isEqualTo: itemName)
        .limit(1)
        .get();
    if (menuSnapshot.docs.isNotEmpty) {
      final menuData = menuSnapshot.docs.first.data() as Map<String, dynamic>;
      return menuData['price'] ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back!\nAdmin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                FutureBuilder<Map<String, dynamic>>(
                  future: fetchSalesData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildSkeletonLoader();
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Unable to load sales data."),
                      );
                    }
                    final salesData = snapshot.data!;
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('feedback')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildSkeletonLoader();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No feedback available."));
                        }

                        final feedbackDocs = snapshot.data!.docs;

                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          children: [
                            _buildAdminStatCard(
                                'Today Sales',
                                '\$${salesData['today']!.toStringAsFixed(2)}',
                                Colors.red[700]!,
                                Colors.red[300]!),
                            _buildAdminStatCard(
                                'Monthly Sales',
                                '\$${salesData['month']!.toStringAsFixed(2)}',
                                Colors.green[600]!,
                                Colors.green[300]!),
                            _buildAdminStatCard(
                                'Feedbacks Count',
                                feedbackDocs.length.toString(),
                                Colors.orange[600]!,
                                Colors.orange[300]!),
                            _buildAdminStatCard(
                                'Orders Today',
                                '${salesData['ordersToday']}',
                                Colors.blue[600]!,
                                Colors.blue[300]!),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 24),
                // Quick Links Section
                Text(
                  "Quick Links",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildQuickLinkTile(
                  context,
                  title: 'User Management',
                  icon: Icons.people,
                  onTap: () {
                    Get.toNamed('/adminUsermanagement');
                  },
                ),
                _buildQuickLinkTile(
                  context,
                  title: 'Customer List',
                  icon: Icons.people,
                  onTap: () {
                     Get.toNamed('/customerlist');
                   
                  },
                ),
                _buildQuickLinkTile(
                  context,
                  title: 'Menu Management',
                  icon: Icons.menu,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageMenuScreen()),
                    );
                  },
                ),
                _buildQuickLinkTile(
                  context,
                  title: 'Feedbacks',
                  icon: Icons.feedback,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedbackListPage()),
                    );
                  },
                ),

                _buildQuickLinkTile(
                  context,
                  title: 'Sales Report',
                  icon: Icons.report,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesPage()),
                    );
                  },
                ),
               
                _buildQuickLinkTile(
                  context,
                  title: 'Change Password',
                  icon: Icons.lock,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()),
                    );
                  },
                ),
                _buildQuickLinkTile(
                  context,
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logout Function
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  // Skeleton Loader for Cards
  Widget _buildSkeletonLoader() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2 / 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      children: [
        _buildSkeletonCard(),
        _buildSkeletonCard(),
        _buildSkeletonCard(),
        _buildSkeletonCard(),
      ],
    );
  }

  // Skeleton Card Design
  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 12,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Container(
                width: 120,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stat Cards (Once Data is Loaded)
  Widget _buildAdminStatCard(String title, String value, Color color1, Color color2) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Link Tile
  Widget _buildQuickLinkTile(BuildContext context,
      {required String title, required IconData icon, required Function onTap}) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () => onTap(),
    );
  }
}
