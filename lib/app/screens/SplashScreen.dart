import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoRotation;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Controller for Logo Animation (Rotation and Scale)
    _logoController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Controller for Text Animation (Fade and Slide)
    _textController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );
    _textSlide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Start the animations
    _logoController.forward();
    _textController.forward();

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate splash screen delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userRole = prefs.getString('userRole');

    if (isLoggedIn && userRole != null) {
      // Navigate to the appropriate screen based on the saved user role
      switch (userRole) {
        case 'admin':
          Get.offNamed(AppRoutes.admin);
          break;
        case 'manager':
          Get.offNamed(AppRoutes.manager);
          break;
        case 'staff':
          Get.offNamed(AppRoutes.staff);
          break;
        case 'customer':
          Get.offNamed(AppRoutes.customer);
          break;
        default:
          Get.offNamed(AppRoutes.login);
      }
    } else {
      // No user logged in, go to login screen
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Updated background color with a warm tone
      backgroundColor: Color(0xFFF6E1B3), // Light warm beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation (Rotation + Scale + Fade-In)
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _logoRotation.value * 2 * 3.1416, // 360° rotation
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: FadeTransition(
                      opacity: _logoController,
                      child: Icon(Icons.restaurant, size: 100, color: Color(0xFF9E2A2F)), // Rich burgundy color for the icon
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Text Animation (Slide + Fade-In)
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  'Plaza Restaurant',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9E2A2F), // Rich burgundy for the text
                    letterSpacing: 2,
                    height: 1.4, // Adjusting line height for better spacing
                  ),
                  textAlign: TextAlign.center, // Center aligning the text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
