
import 'package:flutter/material.dart';
import 'package:restro/app/screens/customer/CategoryUpload.dart';
import 'package:restro/app/screens/customer/FavouritesScreen.dart';
import 'package:restro/app/screens/customer/MyOrder.dart';
import 'package:restro/app/screens/customer/UserProfileScreen.dart';
import 'package:restro/app/screens/customer/menu_browsing.dart';

import '../../../utils/theme.dart';

class MenuBrowsingScreen extends StatefulWidget {
  @override
  _MenuBrowsingScreenState createState() => _MenuBrowsingScreenState();
}

class _MenuBrowsingScreenState extends State<MenuBrowsingScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    FavouritesScreen(),
    CategoryUploadPage(),
    MyOrdersScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'My Orders',
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
