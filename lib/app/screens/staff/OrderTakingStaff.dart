import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTakingScreen extends StatefulWidget {
  final String? initialItemName;

  OrderTakingScreen({this.initialItemName});

  @override
  _OrderTakingScreenState createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends State<OrderTakingScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedTableNumber;
  List<String> itemSuggestions = []; // Stores item suggestions

  @override
  void initState() {
    super.initState();
    if (widget.initialItemName != null) {
      itemNameController.text = widget.initialItemName!;
    }
    // Listen for changes to item name for search
    itemNameController.addListener(fetchItemSuggestions);
  }

  // Fetch menu item suggestions based on user input
  Future<void> fetchItemSuggestions() async {
    final query = itemNameController.text.trim();
    if (query.isEmpty) {
      setState(() {
        itemSuggestions.clear();
      });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .limit(5)
        .get();

    setState(() {
      itemSuggestions = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> submitOrder() async {
    final itemName = itemNameController.text;
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final notes = notesController.text;

    if (itemName.isEmpty || quantity <= 0 || selectedTableNumber == null) {
      return;
    }

    // Check if the entered item name is a valid menu item
    final menuSnapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('name', isEqualTo: itemName)
        .get();

    if (menuSnapshot.docs.isEmpty) {
      // Display an error message if item is not in the menu
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Menu Item"),
          content: Text("The item '$itemName' is not on the menu."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final orderDetails = {
      'item': itemName,
      'quantity': quantity,
      'notes': notes,
      'tableNumber': selectedTableNumber,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
      'date': DateTime.now(),  // Local date and time for order
    };

    await FirebaseFirestore.instance.collection('orders').add(orderDetails);
    itemNameController.clear();
    quantityController.clear();
    notesController.clear();
    setState(() {
      itemSuggestions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFA93036), // Burgundy
        foregroundColor: Colors.white,
        title: const Text('Take Order'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              // Display item suggestions
              if (itemSuggestions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(itemSuggestions[index]),
                      onTap: () {
                        itemNameController.text = itemSuggestions[index];
                        setState(() {
                          itemSuggestions.clear();
                        });
                      },
                    );
                  },
                ),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTableNumber,
                hint: const Text("Select Table Number"),
                onChanged: (value) {
                  setState(() {
                    selectedTableNumber = value;
                  });
                },
                items: ['1', '2', '3', '4', '5'].map((table) {
                  return DropdownMenuItem<String>(
                    value: table,
                    child: Text("Table $table"),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: submitOrder,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA93036), // Burgundy
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Submit Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
