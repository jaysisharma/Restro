import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restro/app/screens/customer/MenuItemDetailScreen.dart';
import 'package:restro/app/screens/customer/component/AddressWidget.dart';
import 'package:restro/app/screens/customer/component/BookTableBanner.dart';
import 'package:restro/app/screens/customer/component/DishList.dart';
import 'package:restro/app/screens/customer/component/HorizontalDish.dart';
import 'package:restro/app/screens/customer/component/SectionHeader.dart';
import 'package:restro/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    // Add sample data if needed
  ];

  final List<Map<String, String>> categories = [
    {
      "name": "Burger",
      "image":
          "https://www.foodandwine.com/thmb/pwFie7NRkq4SXMDJU6QKnUKlaoI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Ultimate-Veggie-Burgers-FT-Recipe-0821-5d7532c53a924a7298d2175cf1d4219f.jpg"
    },
    {
      "name": "Fries",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png"
    },
    {
      "name": "Pizza",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg"
    },
    {
      "name": "Biryani",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Hot_dog_with_mustard.png/1200px-Hot_dog_with_mustard.png"
    },
    {
      "name": "More",
      "image":
          "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/donot-poster-design-template-f0b50d444dcd6e2faf686b35d47481e1_screen.jpg?ts=1720220444"
    },
  ];

  final List<Map<String, dynamic>> recommendedItems = [
    {
      "name": "Spaghetti",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 10.99,
      "rating": 4.5,
      "reviews": 250,
      "description": "Classic Italian pasta with marinara sauce."
    },
    {
      "name": "Burger",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 5.99,
      "rating": 4.2,
      "reviews": 150,
      "description": "Juicy beef patty with lettuce, tomato, and cheese."
    },
    {
      "name": "Fried Chicken",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 8.99,
      "rating": 4.6,
      "reviews": 300,
      "description": "Crispy fried chicken served with gravy."
    },
    {
      "name": "Caesar Salad",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png",
      "price": 5.49,
      "rating": 4.2,
      "reviews": 180,
      "description": "Crisp lettuce with Caesar dressing and croutons."
    },
  ];

  final List<Map<String, dynamic>> trendingItems = [
    {
      "name": "Pasta Primavera",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png",
      "price": 12.99,
      "rating": 4.6,
      "reviews": 300,
      "description": "Fresh pasta with a medley of seasonal vegetables."
    },
    {
      "name": "Fish Tacos",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 9.99,
      "rating": 4.3,
      "reviews": 180,
      "description": "Grilled fish with a tangy salsa and avocado."
    },
    {
      "name": "Fried Chicken",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 8.99,
      "rating": 4.6,
      "reviews": 300,
      "description": "Crispy fried chicken served with gravy."
    },
    {
      "name": "Caesar Salad",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png",
      "price": 5.49,
      "rating": 4.2,
      "reviews": 180,
      "description": "Crisp lettuce with Caesar dressing and croutons."
    },
  ];

  final List<Map<String, dynamic>> allDishes = [
    {
      "name": "Fried Chicken",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 8.99,
      "rating": 4.6,
      "reviews": 300,
      "description": "Crispy fried chicken served with gravy."
    },
    {
      "name": "Caesar Salad",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png",
      "price": 5.49,
      "rating": 4.2,
      "reviews": 180,
      "description": "Crisp lettuce with Caesar dressing and croutons."
    },
    {
      "name": "Fried Chicken",
      "image":
          "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/10/pizza-recipe-1.jpg",
      "price": 8.99,
      "rating": 4.6,
      "reviews": 300,
      "description": "Crispy fried chicken served with gravy."
    },
    {
      "name": "Caesar Salad",
      "image":
          "https://5.imimg.com/data5/SELLER/Default/2023/1/LT/NE/DN/35551975/premium-french-fries-photos-7-png-500x500.png",
      "price": 5.49,
      "rating": 4.2,
      "reviews": 180,
      "description": "Crisp lettuce with Caesar dressing and croutons."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage:
                NetworkImage("https://www.w3schools.com/w3images/avatar2.png"),
          ),
        ),
        title: const AddressWidget(),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          const BookTableBanner(),
          const SizedBox(height: 20),
          CategoryList(categories: categories),
          const SectionHeader(title: "Trending Items"),
          HorizontalDishList(items: trendingItems),
          const SectionHeader(title: "Recommended Dishes"),
          HorizontalDishList(items: recommendedItems),
          const SectionHeader(title: "All Dishes"),

          // StreamBuilder for fetching menu data
          DishList()
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<Map<String, String>> categories;

  const CategoryList({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryItemsScreen(
                    categoryName: category["name"]!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      category["image"]!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(category["name"]!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryItemsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryItemsScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  // Track the filter selection (initially no filter applied)
  String? filterCategory;

  Future<List<Map<String, dynamic>>> fetchMenuItems() async {
    try {
      // Fetch all menu items from Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('menu').get();

      // Filter the items where the name contains the category name
      final filteredItems = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((item) => (item['name'] as String).toLowerCase().contains(
              widget.categoryName.toLowerCase())) // Case-insensitive check
          .toList();

      // Apply the Veg/Non-Veg filter if it's set
      if (filterCategory != null) {
        return filteredItems
            .where((item) => item['category'] == filterCategory)
            .toList();
      }

      return filteredItems;
    } catch (e) {
      // Handle any error that might occur
      throw Exception("Error fetching items: $e");
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter by",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text("Veg", style: TextStyle(fontSize: 16)),
                onTap: () {
                  setState(() {
                    filterCategory = 'Veg';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Non-Veg", style: TextStyle(fontSize: 16)),
                onTap: () {
                  setState(() {
                    filterCategory = 'Non-Veg';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                    const Text("Clear Filter", style: TextStyle(fontSize: 16)),
                onTap: () {
                  setState(() {
                    filterCategory = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            tooltip: "Filter",
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect(); // Show shimmer while loading
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final menuItems = snapshot.data ?? [];

          if (menuItems.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 12.0, // Horizontal spacing between grid items
                mainAxisSpacing: 12.0, // Vertical spacing between grid items
                childAspectRatio: 0.75, // Adjust to control the item size ratio
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                // Determine if the item is Veg or Non-Veg based on the category field
                final isVeg = item['category'] == 'Veg';

                return GestureDetector(
                  onTap: () {
                    // Navigate to the item details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuItemDetailScreen(item: item),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            item[
                                "imageUrl"], // Assuming 'imageUrl' is the key for the image
                            width: double.infinity,
                            height: 150, // Height of the image
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isVeg ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isVeg ? 'Veg' : 'Non-Veg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${item["price"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // Displaying 6 items as a placeholder
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 15,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 80,
                  height: 15,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
