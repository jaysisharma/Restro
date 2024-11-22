import 'package:flutter/material.dart';
import 'package:restro/app/screens/customer/MenuItemDetailScreen.dart';

class HorizontalDishList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const HorizontalDishList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuItemDetailScreen(item: item),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item["image"],
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("\$${item["price"]}"),
                  Text("${item["rating"]} ★ (${item["reviews"]} reviews)"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}