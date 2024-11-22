import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restro/app/screens/customer/MenuItemDetailScreen.dart';

class DishList extends StatelessWidget {
  const DishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        }

        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap:
              true, // This allows the ListView to take only the required space
          physics:
              NeverScrollableScrollPhysics(), // Prevent scrolling inside this ListView
          itemCount: data.length,
          itemBuilder: (context, index) {
            var itemData = data[index].data()
                as Map<String, dynamic>; // Access document data

            return ListTile(
              leading: Image.network(
                itemData["imageUrl"],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(itemData['name']),
              trailing: Text("\$${itemData["price"]}"),
              subtitle: Text(
                itemData["description"] != null &&
                        itemData["description"].length > 70
                    ? itemData["description"].substring(0, 70) +
                        "..." // Add "..." for truncation
                    : itemData["description"] ??
                        "No description", // Fallback for null descriptions
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuItemDetailScreen(
                        item: itemData), // Pass the full item data
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
