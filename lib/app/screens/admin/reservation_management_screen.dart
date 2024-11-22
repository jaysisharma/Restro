import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableSetupScreen extends StatefulWidget {
  @override
  _TableSetupScreenState createState() => _TableSetupScreenState();
}

class _TableSetupScreenState extends State<TableSetupScreen> {
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _tableSizeController = TextEditingController();
  String selectedStatus = "Available"; // Default table status

  Future<void> _addTable() async {
  String tableNumber = _tableNumberController.text.trim();
  String tableSize = _tableSizeController.text.trim();

  if (tableNumber.isEmpty || tableSize.isEmpty) {
    _showErrorDialog("Please fill in all fields.");
    return;
  }

  await FirebaseFirestore.instance.collection('tables').add({
    'tableNumber': tableNumber,
    'tableSize': tableSize,
    'status': selectedStatus,
    'bookedBy': null, // Add this to prevent missing field issues
  });

  // Clear input fields
  _tableNumberController.clear();
  _tableSizeController.clear();

  _showSuccessDialog("Table added successfully!");
}


  Future<void> _updateTableStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('tables')
        .doc(docId)
        .update({'status': newStatus});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success', style: TextStyle(color: Colors.green)),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Table Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tableNumberController,
              decoration: InputDecoration(labelText: 'Table Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tableSizeController,
              decoration: InputDecoration(labelText: 'Table Size (e.g., 4 seats)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedStatus,
              items: ["Available", "Not Available", "Booked"].map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addTable,
              child: Text("Add Table"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('tables').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final tables = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      String currentStatus = table['status'];

                      return ListTile(
                        title: Text(
                          'Table ${table['tableNumber']} - Size: ${table['tableSize']}',
                          style: TextStyle(
                            color: currentStatus == "Booked" ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Text("Status: $currentStatus"),
                        trailing: DropdownButton<String>(
                          value: currentStatus,
                          items: ["Available", "Not Available", "Booked"].map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: currentStatus == "Booked"
                              ? null // Disable the dropdown if status is "Booked"
                              : (String? newValue) {
                                  if (newValue != null) {
                                    _updateTableStatus(table.id, newValue);
                                  }
                                },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
