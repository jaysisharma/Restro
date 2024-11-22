import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restro/app/screens/admin/table_screen.dart';
import 'package:restro/app/screens/customer/LoginScreen.dart';

class TableBookingScreen extends StatefulWidget {
  @override
  _TableBookingScreenState createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends State<TableBookingScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _bookTable(String docId) async {
    // You would include additional reservation details here
    await FirebaseFirestore.instance.collection('tables').doc(docId).update({
      'status': 'Booked',
      'bookedBy': userId,
      // Add other fields like name, contact, etc.
    });
    _showSuccessDialog("Table booked successfully!");
  }

  Future<void> _unbookTable(String docId) async {
    await FirebaseFirestore.instance.collection('tables').doc(docId).update({
      'status': 'Available',
      'bookedBy': FieldValue.delete(),
      // Remove other fields here as needed
    });
    _showSuccessDialog("Table unbooked successfully!");
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Success', style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

 Future<void> _book() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TableScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Status"), // Updated title
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
           IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _book,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tables').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final tables = snapshot.data!.docs;
            if (tables.isEmpty) return Center(child: Text('No tables available.'));

            return ListView.builder(
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                final tableData = table.data() as Map<String, dynamic>;
                final tableStatus = tableData['status'] ?? 'Available';
                final bookedBy = tableData['bookedBy'];

                final isBookedByCurrentUser = tableStatus == 'Booked' && bookedBy == userId;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Table ${tableData['tableNumber']} - Size: ${tableData['tableSize']}',
                      style: TextStyle(
                        color: tableStatus == "Booked" ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bookedBy != null ? 'Booked by: $bookedBy' : 'Status: $tableStatus'),
                        // Add more reservation details if necessary
                      ],
                    ),
                    trailing: (tableStatus == 'Available' || isBookedByCurrentUser)
                        ? Switch(
                            value: tableStatus == 'Booked',
                            onChanged: (value) {
                              if (value) {
                                _showBookingConfirmationDialog(table.id);
                              } else if (isBookedByCurrentUser) {
                                _unbookTable(table.id);
                              }
                            },
                          )
                        : null, // Disable toggle for tables booked by other users
                  ),
                );
              },
            );  
          },
        ),
      ),
    );
  }

  void _showBookingConfirmationDialog(String docId) {
    // Similar to previous implementation, but include reservation details
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Confirm Booking'),
        content: Text('Are you sure you want to book this table?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _bookTable(docId);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
