import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

Future<void> loginRequest(
    BuildContext context, String email, String password) async {
  var url = Uri.parse('http://localhost:5001/auth/login');
  var data = {'email': email, 'password': password};

  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response: ${response.body}');
      // Ideally, you should update your UI based on successful response here !!!!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
      // Show the error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error logging in. Please check your credentials.')),
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
