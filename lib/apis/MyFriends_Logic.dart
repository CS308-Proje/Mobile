import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/friendModel.dart';
import '../models/invitationModel.dart';

const storage = FlutterSecureStorage();

class MyFriendsLogic {
  Future<String?> fetchUserId() async {
    return await storage.read(key: 'userId');
  }

  Future<List<Friend>> fetchUserFriends() async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('http://localhost:5001/friends/all'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var friends = data['friends'] as List;

      return friends.map<Friend>((json) => Friend.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load friends');
    }
  }

  Future<void> addFriendById(String userId, String friendId) async {
    final url = Uri.parse('http://localhost:5001/friends/add');

    final Map<String, String> data = {
      'userId': userId,
      'friendId': friendId,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Friend added successfully
      print('Friend added successfully');
    } else {
      // Handle errors if necessary
      print('Error adding friend. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeFriendById(String userId, String friendId) async {
    final url = Uri.parse('http://localhost:5001/friends/remove');

    final Map<String, String> data = {
      'userId': userId,
      'friendId': friendId,
    };

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Friend removed successfully
      print('Friend removed successfully');
    } else {
      print('Error removing friend. Status code: ${response.statusCode}');
    }
  }

  Future<List<Invitation>> fetchUserInvitations() async {
    try {
      String? userId = await fetchUserId();
      String? token = await storage.read(key: 'token');

      if (userId == null || token == null) {
        throw Exception('User ID or token is null');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse('http://localhost:5001/invitation/getallinv'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        List<Invitation> userInvitations = data
            .map((json) => Invitation.fromJson(json))
            .where((invitation) => invitation.targetUserId == userId)
            .toList();

        return userInvitations;
      } else {
        throw Exception('Failed to load invitations');
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Rethrow the exception
    }
  }

  Future<void> updateInvitationStatus(
      String invitationId, String status) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Example:
    final url =
        Uri.parse('http://localhost:5001/invitation/update/$invitationId');

    final Map<String, String> data = {
      'status': status,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Invitation status updated successfully
      print('Invitation status updated successfully');
    } else {
      // Handle errors if necessary
      print(
          'Error updating invitation status. Status code: ${response.statusCode}');
    }
  }

  Future<void> sendFriendRequest(String userId, String targetUserId) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.parse(
        'http://localhost:5001/invitation/createInvitation/$targetUserId');

    final Map<String, String> data = {
      'userId': userId,
      'targetUserId': targetUserId,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Friend request sent successfully
      print('Friend request sent successfully');
    } else {
      // Handle errors if necessary
      print(
          'Error sending friend request. Status code: ${response.statusCode}');
    }
  }
}
