import 'package:flutter/material.dart';

class TableStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Status"), // Changed from "Table Management" to "Table Status"
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Table Overview Section
                  Text("Table Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TableOverview(),
                  SizedBox(height: 20),
                  // Reservation Details Section
                  Text("Reservation Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ReservationForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Table No')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Reserved By')),
        DataColumn(label: Text('Actions')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('Available')),
          DataCell(Text('')),
          DataCell(Row(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.cancel), onPressed: () {}),
            ],
          )),
        ]),
        DataRow(cells: [
          DataCell(Text('2')),
          DataCell(Text('Reserved')),
          DataCell(Text('John Doe')),
          DataCell(Row(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.cancel), onPressed: () {}),
            ],
          )),
        ]),
      ],
    );
  }
}

class ReservationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: InputDecoration(labelText: 'Name')),
        TextField(decoration: InputDecoration(labelText: 'Contact')),
        Row(
          children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Date'))),
            SizedBox(width: 10),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Time'))),
          ],
        ),
        TextField(decoration: InputDecoration(labelText: 'Duration (e.g., 2 hours)')),
        TextField(decoration: InputDecoration(labelText: 'Special Requests')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Add Reservation")),
            ElevatedButton(onPressed: () {}, child: Text("Update Reservation")),
          ],
        ),
      ],
    );
  }
}
