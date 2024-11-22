
import 'package:get/get.dart';
import 'package:restro/app/routes/route_names.dart';
import 'package:restro/app/screens/admin/staff_page.dart';
import 'package:restro/app/screens/admin/table_booking_screen.dart';
import 'package:restro/app/screens/customer/Cart.dart';
import 'package:restro/app/screens/customer/MenuBrowsingScreen.dart';
import 'package:restro/app/screens/customer/UserProfileScreen.dart';
import 'package:restro/app/screens/customer/menu_browsing.dart';

import '../screens/admin/CRUD.dart';
import '../screens/admin/ManageMenuScreen.dart';
import '../screens/SplashScreen.dart';
import '../screens/admin/CustomerList.dart';
import '../screens/admin/Feedbacks.dart';
import '../screens/admin/admin_page.dart';
import '../screens/admin/manager_page.dart';
import '../screens/customer/LoginScreen.dart';
import '../screens/customer/RegisterScreen.dart';
import '../screens/manager/SalesPage.dart';

class AppPages {
  static final routes = [
    // SplashScreen Page Route
    GetPage(
      name: AppRoutes.initial,
      page: () => SplashScreen(),
    ),

    // Admin Page Route
    GetPage(
      name: AppRoutes.admin,
      page: () => AdminPage(),
    ),
    
    // Manager Page Route
    GetPage(
      name: AppRoutes.manager,
      page: () => ManagerPage(),
    ),
    
    // Staff Page Route
    GetPage(
      name: AppRoutes.staff,
      page: () => StaffPage(),
    ),
    
    // Customer Login Route
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
     GetPage(
      name: AppRoutes.tablebook,
      page: () => TableBookingScreen(),
    ),
    // Customer Register Route
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
    ),

    // Admin User Management
    GetPage(
      name: AppRoutes.adminUsermanagement,
      page: () => AdminUserManagementScreen(),
    ),
    
    // Customer List
    GetPage(
      name: AppRoutes.customerlist,
      page: () => CustomerListScreen(),
    ),

    GetPage(
      name: AppRoutes.cart,
      page: () => Cart(),
    ),
    
    
    // Menu Management
    GetPage(
      name: AppRoutes.manageMenu,
      page: () => ManageMenuScreen(),
    ),
    
    // Feedbacks
    GetPage(
      name: AppRoutes.feedbacks,
      page: () => FeedbackListPage(),
    ),
    
    // Sales Report
    GetPage(
      name: AppRoutes.salesReport,
      page: () => SalesPage(),
    ),

     GetPage(
      name: AppRoutes.customer,
      page: () => MenuBrowsingScreen(),
    ),
    
    // Change Password
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordScreen(),
    ),
  ];
}