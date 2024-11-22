import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UserController extends GetxController {
  var users = <Map<String, dynamic>>[].obs; // Observable list of users
  final String domain = 'cafeplaza.com'; // Restaurant domain

  // Function to generate a unique email
  String generateUniqueEmail(String firstName) {
    final random = Random();
    int randomNumber = 100 + random.nextInt(900); // Generates a 3-digit number
    String cleanedFirstName = firstName.replaceAll(' ', '').toLowerCase();
    return '$cleanedFirstName$randomNumber@$domain';
  }

  // Function to generate a unique password
  String generateUniquePassword() {
    const length = 8;
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%&*';
    final random = Random();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  // Function to add a new user
  Future<void> addUser(String firstName, String originalEmail, String role, String phone) async {
    // Check for existing original email
    final existingUser = await FirebaseFirestore.instance
        .collection('users')
        .where('originalEmail', isEqualTo: originalEmail)
        .get();

    if (existingUser.docs.isNotEmpty) {
      Get.snackbar('Error', 'Original email already exists.', snackPosition: SnackPosition.BOTTOM);
      return; // Stop execution if email exists
    }

    String uniqueEmail = generateUniqueEmail(firstName);
    
    // Check for unique email existence
    var existingUniqueEmail = await FirebaseFirestore.instance
        .collection('users')
        .where('uniqueEmail', isEqualTo: uniqueEmail)
        .get();

    // If unique email already exists, regenerate it
    while (existingUniqueEmail.docs.isNotEmpty) {
      uniqueEmail = generateUniqueEmail(firstName);
      existingUniqueEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('uniqueEmail', isEqualTo: uniqueEmail)
          .get();
    }

    String uniquePassword = generateUniquePassword();

    // Store the user in Firestore
    await FirebaseFirestore.instance.collection('users').add({
      'name': firstName,
      'originalEmail': originalEmail,
      'uniqueEmail': uniqueEmail,
      'password': uniquePassword,
      'role': role,
      'phone': phone,
    });

    // Send credentials to the original email
    await sendEmail(originalEmail, uniqueEmail, uniquePassword);
    loadUsers(); // Refresh the user list
  }

  // Function to send email
  Future<void> sendEmail(String recipientEmail, String uniqueEmail, String password) async {
    final smtpServer = gmail('jsharma852@rku.ac.in', 'oqynqsywqdthmvyc'); // Use your actual credentials

    final message = Message()
      ..from = Address('your_email@gmail.com', 'Restaurant Admin')
      ..recipients.add(recipientEmail)
      ..subject = 'Your Restaurant Admin Account Credentials'
      ..text = 'Hello,\n\n'
          'Here are your login credentials for the restaurant admin system:\n'
          'Unique Email: $uniqueEmail\n'
          'Password: $password\n\n'
          'Please keep this information secure.\n\n'
          'Best regards,\n'
          'Restaurant Admin Team';

    try {
      await send(message, smtpServer);
      print('Credentials email sent successfully!');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }

  // Function to delete a user
  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    loadUsers(); // Refresh the user list
  }

  // Load users from Firestore
  void loadUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    users.assignAll(snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the user data
      return data;
    }));
  }
}
