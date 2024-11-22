import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  var user = FirebaseAuth.instance.currentUser;

  // Function to update the display name
  Future<void> updateUserName(String newName) async {
    try {
      // Update the display name
      await user?.updateDisplayName(newName);
      await user?.reload(); // Reload user to fetch updated information
      user = FirebaseAuth.instance.currentUser; // Fetch updated user
      update(); // Refresh the UI to show updated info
    } catch (e) {
      print('Error updating user name: $e');
      Get.snackbar("Error", "Failed to update profile");
    }
  }
}
