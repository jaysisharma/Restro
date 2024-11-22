import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register(String email, String password, String role) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'role': role,
    });
  }

  Future<void> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    String role = userDoc['role'];
    
    // You can navigate to different screens based on the user role here.
    // For example:
    // if (role == 'Admin') {
    //   // Navigate to Admin Dashboard
    // } else if (role == 'Manager') {
    //   // Navigate to Manager Dashboard
    // } else if (role == 'Staff') {
    //   // Navigate to Staff Dashboard
    // }
  }
}
