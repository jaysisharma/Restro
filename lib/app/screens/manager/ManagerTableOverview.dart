import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableStatusOverviewScreen extends StatefulWidget {
  @override
  _TableStatusOverviewScreenState createState() =>
      _TableStatusOverviewScreenState();
}

class _TableStatusOverviewScreenState extends State<TableStatusOverviewScreen> {
  String? selectedFilter;
  int totalAvailable = 0;
  int totalBooked = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Table Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFA93036), // Rich burgundy
      ),
      body: Container(
        // color: Color(0xFFF6E1B3), // Light warm beige
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tables').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No tables available."));
            }

            final tables = snapshot.data!.docs;
            totalAvailable =
                tables.where((doc) => doc['status'] == 'Available').length;
            totalBooked =
                tables.where((doc) => doc['status'] == 'Booked').length;

            final filteredTables = tables.where((doc) {
              final tableStatus = (doc['status'] ?? 'Available') as String;
              if (selectedFilter == null) return true;
              return tableStatus == selectedFilter;
            }).toList();

            return Column(
              children: [
                _buildOverviewSection(),
                _buildFilterMenu(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredTables.length,
                    itemBuilder: (context, index) {
                      final table = filteredTables[index].data()
                          as Map<String, dynamic>;
                      final tableId = filteredTables[index].id;
                      final tableNumber = table['tableNumber'] ?? 'N/A';
                      final tableStatus = table['status'] ?? 'Available';
                      final isAvailable = tableStatus == 'Available';

                      return _buildTableRow(
                          tableId, tableNumber, tableStatus, isAvailable);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper to build the overview section
  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOverviewBox("Available", totalAvailable, Colors.green),
          _buildOverviewBox("Booked", totalBooked, Colors.red),
        ],
      ),
    );
  }

  // Helper to build the filter menu
  Widget _buildFilterMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton<String>(
        value: selectedFilter,
        onChanged: (value) {
          setState(() {
            selectedFilter = value;
          });
        },
        isExpanded: true,
        hint: Text("Filter Tables"),
        items: [
          DropdownMenuItem(value: null, child: Text("Show All")),
          DropdownMenuItem(value: "Available", child: Text("Available")),
          DropdownMenuItem(value: "Booked", child: Text("Booked")),
        ],
      ),
    );
  }

  // Helper to build a single table row
  Widget _buildTableRow(
      String tableId, String tableNumber, String tableStatus, bool isAvailable) {
    return GestureDetector(
      onTap: () => _updateTableStatus(tableId, tableStatus),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isAvailable ? Colors.green : Colors.red, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.event_seat, color: Colors.black54, size: 28),
            SizedBox(width: 10),
            Text(
              "Table $tableNumber",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Row(
              children: [
                Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  color: isAvailable ? Colors.green : Colors.red,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text(
                  tableStatus,
                  style: TextStyle(
                    fontSize: 16,
                    color: isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for overview boxes
  Widget _buildOverviewBox(String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Function to update table status
  void _updateTableStatus(String tableId, String currentStatus) async {
    if (currentStatus == 'Available') {
      final bookingInfo = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => BookingDialog(),
      );

      if (bookingInfo != null) {
        FirebaseFirestore.instance.collection('tables').doc(tableId).update({
          'status': 'Booked',
          'customerName': bookingInfo['name'],
          'contactNumber': bookingInfo['contact'],
        });
      }
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm"),
          content: Text("Mark this table as available?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirm"),
            ),
          ],
        ),
      );

      if (confirm == true) {
        FirebaseFirestore.instance.collection('tables').doc(tableId).update({
          'status': 'Available',
          'customerName': null,
          'contactNumber': null,
        });
      }
    }
  }
}

class BookingDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Book Table"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Customer Name"),
          ),
          TextField(
            controller: contactController,
            decoration: InputDecoration(labelText: "Contact Number"),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'name': nameController.text,
              'contact': contactController.text,
            });
          },
          child: Text("Book"),
        ),
      ],
    );
  }
}
