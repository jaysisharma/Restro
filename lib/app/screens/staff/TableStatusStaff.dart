import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableStatusOverviewScreen extends StatefulWidget {
  @override
  _TableStatusOverviewScreenState createState() =>
      _TableStatusOverviewScreenState();
}

class _TableStatusOverviewScreenState extends State<TableStatusOverviewScreen> {
  String?
      selectedFilter; // Stores the selected filter (null for all, "Available" or "Booked")

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Status'),
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Remove back button
        backgroundColor: const Color(0xFFA93036), // Burgundy background color
        foregroundColor: Colors.white, // White text and icons
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list), // Filter icon
            onSelected: (value) {
              setState(() {
                selectedFilter = value; // Update the selected filter
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: null,
                child: Text("Show All"),
              ),
              const PopupMenuItem(
                value: "Available",
                child: Text("Available"),
              ),
              const PopupMenuItem(
                value: "Booked",
                child: Text("Booked"),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tables').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tables available."));
          }

          // Filter the tables based on the selected filter
          final tables = snapshot.data!.docs.where((doc) {
            final tableStatus = (doc['status'] ?? 'Available') as String;
            if (selectedFilter == null) return true; // Show all if no filter
            return tableStatus == selectedFilter; // Apply filter
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index].data() as Map<String, dynamic>;
              final tableNumber = table['tableNumber'] ?? 'N/A';
              final tableStatus = table['status'] ?? 'Available';
              final isAvailable = tableStatus == 'Available';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_seat,
                        color: const Color(0xFFA93036), // Burgundy icon color
                        size: 28,
                      ),
                      const SizedBox(width: 10), // Space between icon and table number
                      Text(
                        "Table $tableNumber",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(), // Pushes status to the far right
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
