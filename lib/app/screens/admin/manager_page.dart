import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restro/app/screens/admin/staff_page.dart';
import 'package:restro/app/screens/customer/LoginScreen.dart';
import 'package:restro/app/screens/manager/ManagerTableOverview.dart';
import 'package:restro/app/screens/manager/SalesPage.dart';
import 'package:restro/app/screens/staff/MenuStaffScreen.dart';
import 'package:restro/app/screens/staff/ordermanagement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TableStatusOverviewScreen(),
    OrderManagementScreen(),
    // UserManagementScreen(),
    MenuScreen(),
    SalesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored values
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6E1B3), // Light beige background for the page
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        backgroundColor: Color(0xFFA93036), // Burgundy color for consistency
        child: Icon(Icons.logout, color: Colors.white),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFF6E1B3), // Light beige for navigation bar
        selectedItemColor: Color(0xFFA93036), // Burgundy for selected items
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: 'Table Status'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Sales'),
        ],
      ),
    );
  }
}


class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No users found."));
        }

        // Filter out users with role 'customer'
        final users = snapshot.data!.docs.where((userDoc) {
          final user = userDoc.data() as Map<String, dynamic>;
          return user['role'] != 'customer'; // Exclude customers
        }).toList();

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data() as Map<String, dynamic>;

            // Null-aware operators for safety
            final userName = user['name'] ?? 'Unknown User';
            final userRole = user['role'] ?? 'Unknown Role';

            return ListTile(
              title: Text(userName),
              subtitle: Text("Role: $userRole"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement role editing functionality
                  print("Edit user $userName");
                },
              ),
            );
          },
        );
      },
    );
  }
}

// // Menu Management Screen
// class MenuManagementScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('menu').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text("No menu items available."));
//         }

//         final menuItems = snapshot.data!.docs;

//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: menuItems.length,
//           itemBuilder: (context, index) {
//             final menuItem = menuItems[index].data() as Map<String, dynamic>;
//             return ListTile(
//               title: Text(menuItem['name']),
//               subtitle: Text("Price: ${menuItem['price']}"),
//               trailing: IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {
//                   // Implement CRUD functionality
//                   print("Edit menu item ${menuItem['name']}");
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }



