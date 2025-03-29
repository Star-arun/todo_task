import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'splash_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController(text: "ex1@yopmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "Test@123");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = true; 
  String _errorMessage = '';

  // Login function
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the next screen (e.g., home screen)
       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Splash()),
            );
      debugPrint('User logged in: ${userCredential.user?.email}');
        Fluttertoast.showToast(
                    msg: "Login Success",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to login: $e';
      });
       Fluttertoast.showToast(
                    msg: "Login Failed",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
    }
  }

  // Signup function
  Future<void> _signup() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the next screen (e.g., home screen)
      debugPrint('User signed up: ${userCredential.user?.email}');
       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Splash()),
            );
              Fluttertoast.showToast(
                    msg: "Signin Success",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign up: $e';
      });
        Fluttertoast.showToast(
                    msg: "Signup Failed",
                    gravity: ToastGravity.BOTTOM, // Position of the toast
                    timeInSecForIosWeb: 2,
                  );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Firebase Auth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (_errorMessage.isNotEmpty) 
              //   Text(
              //     _errorMessage,
              //     style: const TextStyle(color: Colors.red),
              //   ),
              Image.asset("asset/todo_logo.png",scale: 4,),
               const SizedBox(height: 60),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordVisible, 
              
                decoration:  InputDecoration(labelText: 'Password', suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                    });
                  },
                ),),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: _login,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,
            minimumSize: const Size(600, 50), // Width: 200, Height: 50
          ),
                child: const Text('Login'),
              
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,
            minimumSize: const Size(600, 50), // Width: 200, Height: 50
          ),
                child: const Text('Signup'),
              ),
               const SizedBox(height: 600),
            ],
          ),
        ),
      ),
    );
  }
}
