// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/auth_controller.dart';

// class RegistrationForm extends StatefulWidget {
//   @override
//   _RegistrationFormState createState() => _RegistrationFormState();
// }

// class _RegistrationFormState extends State<RegistrationForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           TextField(
//             controller: _confirmPasswordController,
//             decoration: InputDecoration(labelText: 'Confirm Password'),
//             obscureText: true,
//           ),
//           SizedBox(height: 20),
//           if (_errorMessage != null) ...[
//             Text(
//               _errorMessage!,
//               style: TextStyle(color: Colors.red),
//             ),
//             SizedBox(height: 10),
//           ],
//           ElevatedButton(
//             onPressed: () async {
//               if (_passwordController.text != _confirmPasswordController.text) {
//                 setState(() {
//                   _errorMessage = 'Passwords do not match.';
//                 });
//                 return;
//               }
//               try {
//                 await authController.register(
//                   _emailController.text,
//                   _passwordController.text,
//                 );
//                 // Navigate to the login screen or show success message
//               } catch (e) {
//                 setState(() {
//                   _errorMessage = e.toString();
//                 });
//               }
//             },
//             child: Text('Register'),
//           ),
//         ],
//       ),
//     );
//   }
// }
