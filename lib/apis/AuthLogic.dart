import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/MainPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // secure storage

const storage = FlutterSecureStorage(); // Create an instance of secure storage

Future<void> loginRequest(
    // ****** LOGIN REQUEST
    BuildContext context,
    String email,
    String password) async {
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
      var responseBody = json.decode(response.body);
      if (responseBody != null && responseBody['token'] != null) {
        String token = responseBody['token'];
        await storage.write(key: 'token', value: token); // Store the token

        await fetchAndStoreUserData();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: No token received.')),
        );
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error logging in. Please check your credentials.')),
      );
    }
  } catch (error) {
    print('Error making the request: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Error connecting to the server. Please try again later.')),
    );
  }
}

Future<void> registerRequest(
    BuildContext context,
    String username, // ***** REGISTER REQUEST
    String email,
    String password) async {
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
      var responseBody = json.decode(response.body);
      if (responseBody != null && responseBody['token'] != null) {
        String token = responseBody['token'];
        await storage.write(key: 'token', value: token); // Store the token

        await fetchAndStoreUserData();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
      }
    } else {
      print('Registration failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error registering. Please check your details and try again.')),
      );
    }
  } catch (error) {
    print('Error making the request: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Error connecting to the server. Please try again later.')),
    );
  }
}

Future<void> fetchAndStoreUserData() async {
  var url = Uri.parse('http://localhost:5001/auth/me');
  String? token = await storage.read(key: 'token');

  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Assuming you use Bearer token
    },
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body)['data'];
    await storage.write(key: 'userId', value: data['_id']);
    // Store other necessary data similarly
  } else {
    throw Exception('Failed to fetch user data');
  }
}

Future<void> forgotPasswordRequest(BuildContext context, String email) async {
  var url = Uri.parse('http://localhost:5001/auth/forgotpassword');
  var data = {'email': email};

  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['data'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to send email: ${responseBody['data']}')),
        );
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password.')),
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
