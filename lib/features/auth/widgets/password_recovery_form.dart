// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/auth_controller.dart';

// class PasswordRecoveryForm extends StatefulWidget {
//   @override
//   _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
// }

// class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
//   final _emailController = TextEditingController();
//   String? _successMessage;
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
//             decoration: InputDecoration(labelText: 'Enter your email'),
//           ),
//           SizedBox(height: 20),
//           if (_successMessage != null) ...[
//             Text(
//               _successMessage!,
//               style: TextStyle(color: Colors.green),
//             ),
//             SizedBox(height: 10),
//           ],
//           if (_errorMessage != null) ...[
//             Text(
//               _errorMessage!,
//               style: TextStyle(color: Colors.red),
//             ),
//             SizedBox(height: 10),
//           ],
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 await authController.recoverPassword(_emailController.text);
//                 setState(() {
//                   _successMessage = 'Recovery email sent!';
//                 });
//               } catch (e) {
//                 setState(() {
//                   _errorMessage = e.toString();
//                 });
//               }
//             },
//             child: Text('Send Recovery Email'),
//           ),
//         ],
//       ),
//     );
//   }
// }
