import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  // List of booleans to track the booking status of each regular table
  List<List<bool>> tableStatus = [
    [false, false], // Row 1: Table 1 (unbooked), Table 2 (unbooked)
    [false, false], // Row 2: Table 3 (unbooked), Table 4 (unbooked)
  ];

  // Boolean to track the booking status of the circular table
  bool isCircularTable1Booked = false;
  bool isCircularTable2Booked = false;

  // Toggle the booking status when a regular table is clicked
  void toggleBooking(int row, int col) {
    setState(() {
      tableStatus[row][col] = !tableStatus[row][col];
    });
  }

  // Toggle the booking status of the circular tables
  void toggleCircularTableBooking1() {
    setState(() {
      isCircularTable1Booked = !isCircularTable1Booked;
    });
  }

  void toggleCircularTableBooking2() {
    setState(() {
      isCircularTable2Booked = !isCircularTable2Booked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Table'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double circularTableSize = screenWidth * 0.15; // Circular table size

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTableColumn(context, screenWidth * 0.4, circularTableSize),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Method to build a column of regular tables
  Widget _buildTableColumn(BuildContext context, double tableWidth, double circularTableSize) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _table(tableWidth, "1", 0, 0),
                _table(tableWidth, "2", 0, 1),
              ],
            ),
            SizedBox(height: 20),
            // Circular Table Section (Tables 3 and 4)
            Text("Circular Tables", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Row(
              children: [
                _circularTable(circularTableSize, 1),
                SizedBox(width: 10),
                _circularTable(circularTableSize, 2),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Updated _table widget with toggle functionality
  Widget _table(double width, String tableLabel, int row, int col) {
    bool isBooked = tableStatus[row][col];
    Color tableColor = isBooked ? Colors.green.shade200 : Colors.grey.shade300;

    return GestureDetector(
      onTap: () => toggleBooking(row, col), // Toggle booking status on tap
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tableColumn(tableColor),
                  _tableColumn(tableColor),
                ],
              ),
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: isBooked ? Colors.green.shade400 : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  tableLabel, // Use the label number instead of table name
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tableColumn12(tableColor),
                  _tableColumn12(tableColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a regular table column
  Widget _tableColumn(Color tableColor) {
    return Column(
      children: [
        Container(
          height: 15,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 35,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor,
          ),
        ),
      ],
    );
  }

  Widget _tableColumn12(Color tableColor) {
    return Column(
      children: [
        Container(
          height: 35,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 15,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor,
          ),
        ),
      ],
    );
  }

  // Circular table widget with dynamic size and booking functionality
  Widget _circularTable(double size, int tableNumber) {
    // Use the same logic to determine the booking status for the circular tables
    Color tableColor = (tableNumber == 1)
        ? (isCircularTable1Booked ? Colors.green.shade200 : Colors.grey.shade300)
        : (isCircularTable2Booked ? Colors.green.shade200 : Colors.grey.shade300);

    return GestureDetector(
      onTap: () {
        // Toggle the booking status of the appropriate circular table
        if (tableNumber == 1) {
          toggleCircularTableBooking1();
        } else {
          toggleCircularTableBooking2();
        }
      },
      child: Column(
        children: [
          _tableColumn(tableColor), // Column 1 is green when booked
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tableColumn3(tableColor), // Column 3 is green when booked
              SizedBox(width: 20),
              Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tableColor, // The circular table is green when booked
                ),
                child: Center(
                  child: Text(
                    "Circular $tableNumber", // Adjusted the text size for Circular table
                    style: TextStyle(
                        fontSize: 16, // Adjusted the text size here
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              _tableColumn2(tableColor), // Column 2 is green when booked
            ],
          ),
          SizedBox(height: 10),
          _tableColumn(tableColor), // Column 1 is green when booked
        ],
      ),
    );
  }

  // Helper methods for circular table columns (now all columns change color with the table)
  Widget _tableColumn2(Color tableColor) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor, // Column color is green when booked
          ),
        ),
        SizedBox(width: 10),
        Container(
          height: 45,
          width: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor, // Column color is green when booked
          ),
        ),
      ],
    );
  }

  Widget _tableColumn3(Color tableColor) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor, // Column color is green when booked
          ),
        ),
        SizedBox(width: 5),
        Container(
          height: 45,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tableColor, // Column color is green when booked
          ),
        ),
      ],
    );
  }
}
