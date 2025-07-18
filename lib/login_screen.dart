import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final existingUser = objectBoxHelper.getUser();
    if (existingUser == null) {
      objectBoxHelper.savePassword("1234"); // Save the default password if none exists.
    }
  }

  void _handleLogin() {
    final input = _passwordController.text.trim();
    if (input.isEmpty) {
      _showMessage("Please enter password");
      return;
    }
    final isValid = objectBoxHelper.verifyPassword(input);
    if (isValid) {
      _showMessage("Login Successful");
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _showMessage("Invalid password");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _handleForgotPassword() {
    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Security Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What is Your Primary School Name?'),
            const SizedBox(height: 10),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final answer = answerController.text.trim().toLowerCase();
              if (answer == 'iqra education system'.toLowerCase()) {
                Navigator.of(ctx).pop();
                _showMessage("Login Password is 1234");
              } else {
                Navigator.of(ctx).pop();
                _showMessage("Incorrect answer. Try again.");
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Routine Tracker',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/profile.png')),
            const SizedBox(height: 20),
            const Text(
              'Rao Muhammad Ahsan Saleem',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.brown,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(27)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                ),
                onPressed: _handleLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
