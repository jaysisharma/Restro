import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 10),
          ],
          ElevatedButton(
            onPressed: () async {
              try {
                await authController.login(
                  _emailController.text,
                  _passwordController.text,
                );
                // Navigate to the home screen or show success message
              } catch (e) {
                setState(() {
                  _errorMessage = e.toString();
                });
              }
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text('Don\'t have an account? Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/password-recovery');
            },
            child: Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }
}
