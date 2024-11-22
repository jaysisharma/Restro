import 'package:flutter/material.dart';
import 'package:restro/app/screens/admin/CRUD.dart';
import 'package:restro/app/screens/admin/ManageMenuScreen.dart';

import '../app/screens/admin/manager_page.dart';

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Navigation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Manage Staff Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
              },
              child: Text("Manage Staff"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Manage Menu Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageMenuScreen()),
                );
              },
              child: Text("Manage Menu"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            // Add more buttons for other management features as needed
          ],
        ),
      ),
    );
  }
}
