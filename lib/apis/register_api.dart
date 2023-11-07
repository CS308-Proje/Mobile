import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/MainPage.dart';

Future<void> registerRequest(BuildContext context, String username,
    String email, String password) async {
  var url = Uri.parse(
      'http://localhost:5001/auth/register'); // Modify the endpoint if needed
  var data = {
    'name':
        username, // Using the provided username for both 'name' and 'username'
    'username': username,
    'email': email,
    'password': password,
  };

  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Registration successful');
      print('Response: ${response.body}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
    } else {
      print('Registration failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error registering. Please check your details and try again.')),
      );
    }
  } catch (error) {
    print('Error making the request: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Error connecting to the server. Please try again later.')),
    );
  }
}
