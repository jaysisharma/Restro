import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_router.dart';
import 'app/routes/route_names.dart';
import 'app/screens/customer/controller/MenuItemController.dart';
import 'firebase_options.dart';
import 'features/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize controllers
  Get.put(AuthController());
  Get.put(MenuItemController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasData) {
//           // User is logged in, check their role in Firestore
//           return FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(snapshot.data!.uid)
//                 .get(),
//             builder: (context, userSnapshot) {
//               if (userSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (userSnapshot.hasData && userSnapshot.data!.exists) {
//                 String role = userSnapshot.data!['role'];

//                 // Navigate based on role
//                 switch (role) {
//                   case 'admin':
//                     return AdminPage();
//                   case 'manager':
//                     return ManagerPage();
//                   case 'staff':
//                     return StaffPage();
//                   case 'customer':
//                     return MenuBrowsingScreen();
//                   default:
//                     return ErrorScreen(
//                         message: 'Invalid role assigned to the user.');
//                 }
//               } else {
//                 return ErrorScreen(message: 'User data not found.');
//               }
//             },
//           );
//         } else {
//           return LoginScreen();
//         }
//       },
//     );
//   }
// }

// class ErrorScreen extends StatelessWidget {
//   final String message;

//   ErrorScreen({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(message, style: TextStyle(color: Colors.red, fontSize: 18)),
//       ),
//     );
//   }
// }
