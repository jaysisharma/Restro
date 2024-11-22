import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  // List to store the items in the cart
  var cartItems = <Map<String, dynamic>>[].obs;

  // Add item to the cart
  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  // Remove item from the cart
  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  // Update the quantity of an item
  void updateQuantity(int index, int quantity) {
    cartItems[index]['quantity'] = quantity;
  }

  // Calculate total price
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }
}
