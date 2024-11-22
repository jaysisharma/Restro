import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restro/app/screens/staff/ChangePasswordScreenStaff.dart';
import 'package:restro/app/screens/staff/EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  // Function to submit feedback
  Future<void> submitFeedback(String feedbackText) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && feedbackText.isNotEmpty) {
      await FirebaseFirestore.instance.collection('feedback').add({
        'userId': userId,
        'feedback': feedbackText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      feedbackController.clear(); // Clear the text field after submitting
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Ensure the user is authenticated
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFA93036), // Burgundy color for the app bar
        ),
        body: const Center(child: Text("Please log in to view your profile.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor:
            const Color(0xFFA93036), // Burgundy color for the app bar
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        user.photoURL ??
                            'https://www.w3schools.com/w3images/avatar2.png', // Default avatar if photoURL is null
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName ?? 'User Name',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email ?? 'Email not available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit Profile and Change Password buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          context,
                          'Edit Profile',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          context,
                          'Change Password',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Display feedback section
              const Text(
                "All Feedback:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),

              // Show dynamic feedback from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('feedback')
                    .where('userId', isEqualTo: user.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No feedback yet."));
                  }

                  final feedbackDocs = snapshot.data!.docs;
                  return Column(
                    children: feedbackDocs.map((doc) {
                      final feedbackData = doc.data() as Map<String, dynamic>;
                      final feedbackText =
                          feedbackData['feedback'] ?? 'No feedback available';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "• $feedbackText",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Add Feedback section
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Add Feedback',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFA93036), width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                maxLines: 3, // Allow multiple lines for feedback
              ),
              const SizedBox(height: 16),

              // Submit Button
              GestureDetector(
                onTap: () {
                  submitFeedback(feedbackController.text);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA93036), // Burgundy button color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA93036).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Submit Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFA93036), // Burgundy button color
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA93036).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
