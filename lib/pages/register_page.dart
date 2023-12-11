import 'package:flutter/material.dart';
import 'package:srs_mobile/components/square_tile.dart';
import 'login_page.dart';
import '../apis/AuthLogic.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/srs_logoColored.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white, // or any other color
                        filled:
                            true, // This is important. It tells the InputDecoration to use the fillColor
                        hintText: 'Username',
                        prefixIcon: Icon(Icons.person_outline,
                            color: Color(0xFF80A254)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white, // or any other color
                        filled:
                            true, // This is important. It tells the InputDecoration to use the fillColor
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Color(0xFF80A254)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white, // or any other color
                        filled:
                            true, // This is important. It tells the InputDecoration to use the fillColor
                        hintText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Color(0xFF80A254)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white, // or any other color
                        filled:
                            true, // This is important. It tells the InputDecoration to use the fillColor
                        hintText: 'Confirm Password',
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Color(0xFF80A254)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (_confirmPassword != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmPassword = value!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print(
                      _password,
                    );
                    print(_confirmPassword);
                    registerRequest(
                        context, _username, _email, _confirmPassword);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent, // Make the button transparent
                  shadowColor: Colors.transparent, // No elevation shadow
                  padding: const EdgeInsets.all(
                      0), // Reset padding because the Container already has padding
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text('Or continue with',
                      style: TextStyle(color: Colors.grey[300])),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Logic for Google login
                    },
                    child: const SquareTile(
                      imagePath: 'assets/google_icon.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logic for Apple login
                    },
                    child: const SquareTile(
                      imagePath: 'assets/apple_icon.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already a member?",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        color: Color(0xFF80A254),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
