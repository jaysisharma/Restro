import 'package:flutter/material.dart';
import 'package:restro/app/screens/customer/LoginScreen.dart';
import 'package:restro/app/screens/staff/ordermanagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../staff/MenuStaffScreen.dart';
import '../staff/OrderTakingStaff.dart';
import '../staff/StaffProfile.dart';
import '../staff/TableStatusStaff.dart';

class StaffPage extends StatefulWidget {
  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    OrderTakingScreen(),
    TableStatusOverviewScreen(),
    OrderManagementScreen(),
    MenuScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    print("Pressed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored values
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA93036), // Burgundy
        child: const Icon(Icons.logout, color: Colors.white),
        onPressed: _logout,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFA93036), // Burgundy
        unselectedItemColor: Colors.grey[800],
        // backgroundColor: const Color(0xFFF6E1B3), // Warm beige
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Take Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Table Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Order Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
