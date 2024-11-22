import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();
    final currentStatus = orderSnapshot.data()?['status'] ?? '';

    if (currentStatus != newStatus) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
    }
  }

  Stream<QuerySnapshot> fetchOrdersForDate() {
    final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    return FirebaseFirestore.instance
        .collection('orders')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .snapshots();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ) ?? selectedDate;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Widget buildOrderList(List<DocumentSnapshot> orders, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA93036),
            ),
          ),
        ),
        ...orders.map((order) {
          final data = order.data() as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFA93036), width: 1.5),
              borderRadius: BorderRadius.circular(10),
              // color: Color(0xFFF6E1B3),
            ),
            child: ListTile(
              title: Text(
                "${data['item']} (Qty: ${data['quantity']})",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA93036)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Table: ${data['tableNumber']}",
                    style: TextStyle(color: Color(0xFFA93036)),
                  ),
                  Text(
                    "Notes: ${data['notes'] ?? 'No notes available'}",
                    style: TextStyle(color: Color(0xFFA93036), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: DropdownButton<String>(
                value: data['status'],
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFFA93036)),
                style: TextStyle(color: Color(0xFFA93036)),
                underline: Container(
                  height: 2,
                  color: Color(0xFFA93036),
                ),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    updateOrderStatus(order.id, newStatus);
                  }
                },
                items: ['Pending', 'In Progress', 'Completed', 'Canceled']
                    .map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Management',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFA93036),
      ),
      body: Container(
        // color: Color(0xFFF6E1B3),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Date: $formattedDate',
                    style: TextStyle(fontSize: 16, color: Color(0xFFA93036)),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Color(0xFFA93036)),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchOrdersForDate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Color(0xFFA93036)));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No orders found for this date.",
                        style: TextStyle(color: Color(0xFFA93036)),
                      ),
                    );
                  }

                  final orders = snapshot.data!.docs;
                  final pendingOrders = orders.where((o) => o['status'] == 'Pending').toList();
                  final inProgressOrders = orders.where((o) => o['status'] == 'In Progress').toList();
                  final completedOrders = orders.where((o) => o['status'] == 'Completed').toList();
                  final canceledOrders = orders.where((o) => o['status'] == 'Canceled').toList();

                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      if (pendingOrders.isNotEmpty)
                        buildOrderList(pendingOrders, "Pending Orders"),
                      if (inProgressOrders.isNotEmpty)
                        buildOrderList(inProgressOrders, "In Progress Orders"),
                      if (completedOrders.isNotEmpty)
                        buildOrderList(completedOrders, "Completed Orders"),
                      if (canceledOrders.isNotEmpty)
                        buildOrderList(canceledOrders, "Canceled Orders"),
                    ],
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
