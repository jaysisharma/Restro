import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:restro/app/screens/customer/LoginScreen.dart';
import 'package:restro/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get current user
    User? user = _auth.currentUser;

    return Scaffold(
      // backgroundColor: Color(0xFFF6E1B3),  // Light warm beige background
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // elevation: 0,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes back button
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section (Image and Name)
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60, // Adjusted size for better visibility
                            backgroundImage: NetworkImage(
                                user.photoURL ?? 'https://www.example.com/default_avatar.png'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // User Info (Name, Email, and Loyalty Points in one line)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _getUserName(user), // Extracted username from email if displayName is not available
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA93036),  // Rich burgundy for the name
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user.email ?? 'Email not available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Loyalty Points: ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "150", // Example loyalty points, replace with actual value
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,  // Blue for loyalty points
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Full-width container with Box Shadow for actions
                    _buildProfileOption(
                      icon: Icons.person,
                      text: "Edit Profile",
                      onTap: () {
                        // Navigate to Edit Profile screen
                        Get.to(() => EditProfileScreen());
                      },
                    ),

                    // Change Password Section
                    _buildProfileOption(
                      icon: Icons.lock,
                      text: "Change Password",
                      onTap: () {
                        // Navigate to Change Password screen
                        Get.to(() => ChangePasswordScreen());
                      },
                    ),

                    // Help and Support Section
                    _buildProfileOption(
                      icon: Icons.help,
                      text: "Help & Support",
                      onTap: () {
                        // Navigate to Help & Support screen
                        Get.to(() => HelpSupportScreen());
                      },
                    ),

                    // Logout Section
                    _buildProfileOption(
                      icon: Icons.exit_to_app,
                      text: "Logout",
                      onTap: () async {
                        // Handle logout logic
                        await _auth.signOut();
                        Get.offAll(() => LoginScreen());  // Navigate back to Login screen
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper function to extract the username from the email
  String _getUserName(User? user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    } else if (user?.email != null && user!.email!.isNotEmpty) {
      return user.email!.split('@')[0]; // Extract the part before "@" symbol
    }
    return 'No Name Available'; // Default if no username or email found
  }

  // Custom Widget to handle each option's UI and responsiveness
  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for better contrast
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFFA93036)),  // Rich burgundy for icons
                SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(fontSize: 18, color: Color(0xFFA93036)),  // Rich burgundy for text
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.blue),  // Blue arrow for interaction
          ],
        ),
      ),
    );
  }
}


class EditProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    TextEditingController nameController = TextEditingController(text: user?.displayName ?? "");
    TextEditingController emailController = TextEditingController(text: user?.email ?? "");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Text Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Color(0xFFA93036)), // Rich burgundy for label text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFA93036), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF007BFF), width: 2), // Blue focused border
                ),
              ),
            ),
            SizedBox(height: 16),

            // Email Text Field (disabled)
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Color(0xFFA93036)), // Rich burgundy for label text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFA93036), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF007BFF), width: 2), // Blue focused border
                ),
              ),
              enabled: false, // Can't edit email
            ),
            SizedBox(height: 20),

            // Save Changes Button
            GestureDetector(
              onTap: () async {
                try {
                  await user?.updateDisplayName(nameController.text);
                  await user?.reload();
                  Get.back(); // Go back to profile page
                } catch (e) {
                  Get.snackbar("Error", "Failed to update profile", backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Color(0xFFA93036), // Rich burgundy for button
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChangePasswordScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFA93036), // Rich burgundy
        centerTitle: true,
      ),
      body: Container(
        // color: Color(0xFFF6E1B3), // Light warm beige background
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update your password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA93036),
                ),
              ),
              SizedBox(height: 20),
              // Old Password Field
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFA93036)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // New Password Field
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Icons.lock_reset_outlined,
                      color: Color(0xFFA93036)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Change Password Button
              GestureDetector(
                onTap: () async {
                  try {
                    final user = _auth.currentUser;
                    await user?.updatePassword(newPasswordController.text);
                    await user?.reload();
                    Get.back();
                    Get.snackbar(
                      "Success",
                      "Password updated successfully",
                      backgroundColor: Color(0xFFA93036),
                      colorText: Colors.white,
                    );
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to change password",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFA93036), // Rich burgundy
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}


// Help & Support Screen


class HelpSupportScreen extends StatelessWidget {
  // Method to launch the phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone dialer';
    }
  }

  // Method to launch the email app
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email app';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA93036),  // App Color (Burgundy)
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Help & Support",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Text
            Text(
              "Need Assistance? We're here to help!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA93036),  // Rich burgundy for main text
              ),
            ),
            SizedBox(height: 20),

            // Contact Information (Email)
            Row(
              children: [
                Icon(Icons.email, color: Colors.black), // Email icon
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _launchEmail("help@restaurant.com");
                    },
                    child: Text(
                      "help@restaurant.com",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        decoration: TextDecoration.underline,  // Underlined for email
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Additional Information Section
            Text(
              "For urgent matters, you can reach us via phone during business hours.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Contact Options (Phone)
            _buildContactOption(
              icon: Icons.phone,
              text: "+91 12345 67890",  // Example Indian phone number
              color: Colors.green,
              onTap: () {
                _launchPhone("+911234567890");  // Indian phone number
              },
            ),
            SizedBox(height: 20),

            // Support Ticket Section
            GestureDetector(
              onTap: () {
                // Navigate to a support ticket page or form
                // Get.to(() => SupportTicketScreen());
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Color(0xFFA93036),  // Rich burgundy background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Submit a Support Ticket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget for contact options like phone
  Widget _buildContactOption({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}


// Placeholder for the support ticket screen

class SupportTicketScreen extends StatelessWidget {
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text("Support Ticket"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title/Introduction
              Text(
                "Submit a Support Ticket",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA93036), // Rich burgundy for title
                ),
              ),
              SizedBox(height: 20),

              // Issue Type (Dropdown or Text Field)
              Text(
                "Select Issue Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Issue Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: "Technical", child: Text("Technical")),
                  DropdownMenuItem(value: "Billing", child: Text("Billing")),
                  DropdownMenuItem(value: "General Inquiry", child: Text("General Inquiry")),
                ],
                onChanged: (value) {
                  // Handle selection
                },
              ),
              SizedBox(height: 20),

              // Issue Title (Text Field)
              Text(
                "Issue Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _issueController,
                decoration: InputDecoration(
                  labelText: "Enter a brief title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Issue Details (Text Field)
              Text(
                "Issue Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Describe your issue in detail",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              GestureDetector(
                onTap: () {
                  // Submit the ticket (you can handle the form submission here)
                  String issueTitle = _issueController.text;
                  String issueDetails = _detailsController.text;
                  if (issueTitle.isNotEmpty && issueDetails.isNotEmpty) {
                    // Call a method to submit the ticket (to a backend or Firebase)
                    // show a success message or do something
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Ticket Submitted"),
                        content: Text("Your support ticket has been submitted successfully."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Show an error message if any field is empty
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Please fill in all fields before submitting."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFA93036), // Rich burgundy background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Submit Ticket",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
}


