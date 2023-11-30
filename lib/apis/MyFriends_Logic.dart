import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/friendModel.dart';

const storage = FlutterSecureStorage();

class MyFriendsLogic {
  Future<List<Friend>> fetchUserFriends(String userId) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/friends/all/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var friends = data['friends'] as List;

      return friends.map<Friend>((json) => Friend.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load friends');
    }
  }

  static Future<void> addFriendByUsername(String username) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({'username': username});

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/friends/add'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Friend added successfully.');
    } else {
      print('Failed to add friend. Status code: ${response.statusCode}');
      throw Exception('Failed to add friend');
    }
  }
}