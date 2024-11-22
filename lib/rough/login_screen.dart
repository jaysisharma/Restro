// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:restro/CRUD.dart';
// import 'package:restro/admin/admin_page.dart';
// import 'package:restro/admin/manager_page.dart';
// import 'package:restro/admin/staff_page.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _login() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Fetch user data from Firestore to get the role
//       User? user = userCredential.user;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        
//         // Check if the document exists and contains the role
//         if (userDoc.exists) {
//           String role = userDoc['role']; // Assuming the role is stored in the 'role' field

//           // Navigate based on role
//           switch (role) {
//             case 'admin':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserManagementScreen()));
//               break;
//             case 'manager':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerPage()));
//               break;
//             case 'staff':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffPage()));
//               break;
//             default:
//               _showErrorDialog(context, 'Invalid role assigned to the user.');
//           }
//         } else {
//           _showErrorDialog(context, 'User document not found.');
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle login errors
//       String message;
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided for that user.';
//       } else {
//         message = 'Login failed. Please try again.';
//       }
//       _showErrorDialog(context, message);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error', style: TextStyle(color: Colors.red)),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: "Unique Email"),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isLoading ? null : _login,
//               child: isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// Glass Morphism Login Screen



// import 'dart:ui'; // For BackdropFilter
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:restro/CRUD.dart';
// import 'package:restro/app/screens/admin/admin_page.dart';
// import 'package:restro/app/screens/admin/manager_page.dart';
// import 'package:restro/app/screens/admin/staff_page.dart';
// import 'package:restro/app/screens/admin/table_booking_screen.dart';
// import 'package:restro/app/screens/customer/RegisterScreen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool isLoading = false;
//   final _formKey = GlobalKey<FormState>(); // Form key for validation

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         if (userDoc.exists) {
//           String role = userDoc['role'];
//           switch (role) {
//             case 'admin':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage()));
//               break;
//             case 'manager':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerPage()));
//               break;
//             case 'staff':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffPage()));
//               break;
//             case 'customer':
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TableBookingScreen()));
//               break;
//             default:
//               _showErrorDialog(context, 'Invalid role assigned to the user.');
//           }
//         } else {
//           _showErrorDialog(context, 'User document not found.');
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided for that user.';
//       } else {
//         message = 'Login failed. Please try again.';
//       }
//       _showErrorDialog(context, message);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error', style: TextStyle(color: Colors.red)),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage('https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
//                       boxShadow: [
//                         BoxShadow(color: Colors.white.withOpacity(0.1), spreadRadius: 5, blurRadius: 15),
//                       ],
//                     ),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Center(
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       "Welcome Back!",
//                                       style: TextStyle(
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       "Login to your account to continue.",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white.withOpacity(0.8),
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               TextFormField(
//                                 controller: _emailController,
//                                 style: TextStyle(color: Colors.white), // Set text color to white
//                                 decoration: InputDecoration(
//                                   labelText: "Email",
//                                   prefixIcon: Icon(Icons.email, color: Colors.white),
//                                   border: OutlineInputBorder(),
//                                   labelStyle: TextStyle(color: Colors.white),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
//                                     return 'Enter a valid email';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 16),
//                               TextFormField(
//                                 controller: _passwordController,
//                                 style: TextStyle(color: Colors.white), // Set text color to white
//                                 decoration: InputDecoration(
//                                   labelText: "Password",
//                                   prefixIcon: Icon(Icons.lock, color: Colors.white),
//                                   border: OutlineInputBorder(),
//                                   labelStyle: TextStyle(color: Colors.white),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                   ),
//                                 ),
//                                 obscureText: true,
//                                 validator: (value) {
//                                   if (value == null || value.length < 6) {
//                                     return 'Password must be at least 6 characters';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: isLoading ? null : _login,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 15),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: isLoading 
//                                       ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
//                                       : Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Center(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigate to registration page
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
//                                   },
//                                   child: Text("Don't have an account? Register", style: TextStyle(color: Colors.white)),
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Center(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Handle forgot password action
//                                     _showErrorDialog(context, 'Forgot password feature coming soon!');
//                                   },
//                                   child: Text(
//                                     "Forgot Password?",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage('https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
//                       boxShadow: [
//                         BoxShadow(color: Colors.white.withOpacity(0.1), spreadRadius: 5, blurRadius: 15),
//                       ],
//                     ),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Center(
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       "Welcome Back!",
//                                       style: TextStyle(
//                                         fontSize: 30,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       "Login to your account to continue.",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white.withOpacity(0.8),
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               TextFormField(
//                                 controller: _emailController,
//                                 style: TextStyle(color: Colors.white), // Set text color to white
//                                 decoration: InputDecoration(
//                                   labelText: "Email",
//                                   prefixIcon: Icon(Icons.email, color: Colors.white),
//                                   border: OutlineInputBorder(),
//                                   labelStyle: TextStyle(color: Colors.white),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
//                                     return 'Enter a valid email';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 16),
//                               TextFormField(
//                                 controller: _passwordController,
//                                 style: TextStyle(color: Colors.white), // Set text color to white
//                                 decoration: InputDecoration(
//                                   labelText: "Password",
//                                   prefixIcon: Icon(Icons.lock, color: Colors.white),
//                                   border: OutlineInputBorder(),
//                                   labelStyle: TextStyle(color: Colors.white),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.white),
//                                   ),
//                                 ),
//                                 obscureText: true,
//                                 validator: (value) {
//                                   if (value == null || value.length < 6) {
//                                     return 'Password must be at least 6 characters';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: isLoading ? null : _login,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 15),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: isLoading 
//                                       ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
//                                       : Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Center(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigate to registration page
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
//                                   },
//                                   child: Text("Don't have an account? Register", style: TextStyle(color: Colors.white)),
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Center(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Handle forgot password action
//                                     _showErrorDialog(context, 'Forgot password feature coming soon!');
//                                   },
//                                   child: Text(
//                                     "Forgot Password?",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),