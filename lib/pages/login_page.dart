import 'package:flutter/material.dart';
import 'package:srs_mobile/components/square_tile.dart';
import '../apis/AuthLogic.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _showForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();
    TextEditingController verificationController = TextEditingController();
    String emailError = '';
    String verificationError = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF171717),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title:
                  Text("Reset Password", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your mail",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                  ),
                  if (emailError.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(emailError,
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ],
                  SizedBox(height: 20),
                  TextField(
                    controller: verificationController,
                    decoration: InputDecoration(
                      hintText: "verify your mail",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                  ),
                  if (verificationError.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(verificationError,
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ],
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Send", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    // Reset error messages
                    setState(() {
                      emailError = '';
                      verificationError = '';
                    });

                    // Validate email field
                    if (emailController.text.isEmpty) {
                      setState(() {
                        emailError = "Please enter your email";
                      });
                      return; // Stop further execution on error
                    }

                    // Validate verification field
                    if (verificationController.text.isEmpty) {
                      setState(() {
                        verificationError =
                            "Please enter the verification code";
                      });
                      return; // Stop further execution on error
                    }

                    // Validate if both fields have identical content
                    if (emailController.text != verificationController.text) {
                      setState(() {
                        verificationError =
                            "The verification code does not match the email";
                      });
                      return; // Stop further execution on error
                    }

                    forgotPasswordRequest(context, emailController.text)
                        .then((_) {
                      // If you want to close the dialog after the request
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      // Handle any errors here if necessary
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              const SizedBox(height: 30),
              // welcome back, you've been missed!
              Text(
                'Sound Recommendation System',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
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
                        fillColor: Colors.white,
                        filled: true,
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
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _showForgotPasswordDialog,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
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
                        _email); // i can see the mail i entered in the console
                    print(
                        _password); // i can see the password i entered in the console

                    loginRequest(context, _email,
                        _password); // it returns error code:400 however.
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
                        "Sign In",
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
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
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
                    "Not a member?",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      "Register now",
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
