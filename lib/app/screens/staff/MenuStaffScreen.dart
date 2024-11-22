import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:restro/app/screens/staff/OrderTakingStaff.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedFilter = "All"; // Filter for Veg/Non-Veg/All

  void navigateToOrderTakingScreen(BuildContext context, String itemName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTakingScreen(initialItemName: itemName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFFA93036), // Burgundy color for the app bar
        centerTitle: true,
        elevation: 4, // Add subtle shadow
      ),
      backgroundColor: Colors.white, // White background for the Scaffold
      body: Column(
        children: [
          // Filter Chips with subtle animations
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: selectedFilter == "All",
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectedFilter = "All";
                    });
                  },
                  selectedColor: Color(0xFFA93036),
                  labelStyle: TextStyle(
                    color: selectedFilter == "All" ? Colors.white : Colors.black,
                  ),
                ),
                FilterChip(
                  label: Text('Veg'),
                  selected: selectedFilter == "Veg",
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectedFilter = "Veg";
                    });
                  },
                  selectedColor: Color(0xFFA93036),
                  labelStyle: TextStyle(
                    color: selectedFilter == "Veg" ? Colors.white : Colors.black,
                  ),
                ),
                FilterChip(
                  label: Text('Non-Veg'),
                  selected: selectedFilter == "Non-Veg",
                  onSelected: (bool isSelected) {
                    setState(() {
                      selectedFilter = "Non-Veg";
                    });
                  },
                  selectedColor: Color(0xFFA93036),
                  labelStyle: TextStyle(
                    color: selectedFilter == "Non-Veg" ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menu').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Shimmer Effect for loading
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No menu items available.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }

                final menuItems = snapshot.data!.docs.where((doc) {
                  if (selectedFilter == "All") return true;
                  final category = doc['category'] ?? '';
                  return category.toLowerCase() == selectedFilter.toLowerCase();
                }).toList();

                return ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index].data() as Map<String, dynamic>;
                    final itemName = menuItem['name'] ?? 'Unknown Item';
                    final price = menuItem['price'] ?? 'N/A';
                    final imageUrl = menuItem['imageUrl'] ?? ''; // Fetch image URL
                    final category = menuItem['category'] ?? 'Uncategorized';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // Removed card color for transparency
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Image
                            if (imageUrl.isNotEmpty)
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Price: \$${price}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Category: $category",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Add to Cart Button
                            GestureDetector(
                              onTap: () =>
                                  navigateToOrderTakingScreen(context, itemName),
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA93036), // Burgundy button
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 20,
                                ),
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
          ),
        ],
      ),
    );
  }
}
