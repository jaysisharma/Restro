import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/MenuItemController.dart';

class FavouritesScreen extends StatelessWidget {
  final MenuItemController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        automaticallyImplyLeading: true, // Enable back button
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.redAccent,
      ),
      body: Obx(() {
        if (controller.favourites.isEmpty) {
          return const Center(
            child: Text(
              "No favourites added yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            itemCount: controller.favourites.length,
            itemBuilder: (context, index) {
              final item = controller.favourites[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.1),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    "\$${item['price']}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: () {
                      controller.toggleFavorite(item);  // Removes from favourites
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
