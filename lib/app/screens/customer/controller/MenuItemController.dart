import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuItemController extends GetxController {
  // Observables
  var favourites = <Map<String, dynamic>>[].obs; // Favorites list
  var cartItems = <Map<String, dynamic>>[].obs; // Cart list
  var quantity = 1.obs; // Item quantity

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the favorites for the current user from Firebase
  void fetchFavorites() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        favourites.value = List<Map<String, dynamic>>.from(doc['favorites'] ?? []);
      }
    }
  }

  // Add or remove from favorites and update Firestore
  void toggleFavorite(Map<String, dynamic> item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    if (isFavorite(item)) {
      favourites.remove(item);
      _removeFavoriteFromFirebase(user.uid, item);
      Get.snackbar(
        "Removed from Favorites",
        "${item['name']} has been removed from your favorites.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      favourites.add(item);
      _addFavoriteToFirebase(user.uid, item);
      Get.snackbar(
        "Added to Favorites",
        "${item['name']} has been added to your favorites.",
        snackPosition: SnackPosition.TOP,duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Add favorite to Firestore
  void _addFavoriteToFirebase(String userId, Map<String, dynamic> item) {
    _firestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([item]),
    });
  }

  // Remove favorite from Firestore
  void _removeFavoriteFromFirebase(String userId, Map<String, dynamic> item) {
    _firestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([item]),
    });
  }

  // Check if item is in favorites
  bool isFavorite(Map<String, dynamic> item) {
    return favourites.any((favItem) => favItem['id'] == item['id']);
  }

  // Add or remove from cart
  void toggleCart(Map<String, dynamic> item) {
    if (isInCart(item)) {
      cartItems.remove(item);
      Get.snackbar(
        "Removed from Cart",
        "${item['name']} has been removed from your cart.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      cartItems.add({
        ...item,
        'quantity': quantity.value, // Include the current quantity
      });
      Get.snackbar(
        "Added to Cart",
        "${item['name']} has been added to your cart.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Check if item is in the cart
  bool isInCart(Map<String, dynamic> item) {
    return cartItems.any((cartItem) => cartItem['id'] == item['id']);
  }

  // Order item (Placeholder logic)
  void orderItem(Map<String, dynamic> item) {
    Get.snackbar(
      "Order Placed",
      "You have ordered ${item['name']}.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Increase quantity
  void increaseQuantity() {
    quantity.value++;
  }

  // Decrease quantity (minimum 1)
  void decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }
}
