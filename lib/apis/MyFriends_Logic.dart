import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/friendModel.dart';

const storage = FlutterSecureStorage();

class MyFriendsLogic {

  Future<String?> fetchUserId() async {
    return await storage.read(key: 'userId');
  }
  
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

  Future<void> addFriendByUsername(String username) async {
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

  Future<void> addFriendById(String userId, String friendId) async {
    final url = Uri.parse('http://10.0.2.2:5000/friends/add');

    final Map<String, String> data = {
      'userId': userId,
      'friendId': friendId,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Friend added successfully
      print('Friend added successfully');
    } else {
      // Handle errors if necessary
      print('Error adding friend. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeFriendByUsername(String username) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({'username': username});

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/friends/remove'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Friend removed successfully.');
    } else {
      print('Failed to remove friend. Status code: ${response.statusCode}');
      throw Exception('Failed to remove friend');
    }
  }

  Future<void> removeFriendById(String userId, String friendId) async {
    final url = Uri.parse('http://10.0.2.2:5000/friends/remove');

    final Map<String, String> data = {
      'userId': userId,
      'friendId': friendId,
    };

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Friend removed successfully
      print('Friend removed successfully');
    } else {
      print('Error removing friend. Status code: ${response.statusCode}');
    }
  }
}