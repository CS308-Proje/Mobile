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
      Uri.parse('http://10.0.2.2:5001/friends/all'),
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

  Future<void> removeFriendById(String friendId) async {
    String? token = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('http://10.0.2.2:5001/friends/remove/$friendId');

    final response = await http.delete(
      url,
      headers: headers,
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
        Uri.parse('http://10.0.2.2:5001/invitation/getallinv'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<Invitation> userInvitations =
            (data['invitations'] as List<dynamic>).map((json) {
          final Map<String, dynamic> userJson =
              json['user_id'] as Map<String, dynamic>;
          final Friend sender = Friend.fromJson(userJson);

          return Invitation(
            id: json['_id'] as String,
            userId: sender.username,
            targetUserId: json['target_user_id'] as String,
            status: json['status'] as String,
          );
        }).toList();

        return userInvitations;
      } else {
        throw Exception('Failed to load invitations');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
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
        Uri.parse('http://10.0.2.2:5001/invitation/update/$invitationId');

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
      fetchUserInvitations();
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
        'http://10.0.2.2:5001/invitation/createInvitation/$targetUserId');

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

  Future<void> allowFriendRecommendations(String friendId) async {
    try {
      String? token = await storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final url =
          Uri.parse('http://10.0.2.2:5001/friends/allowfriend/$friendId');

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Friend recommendations allowed successfully');
      } else {
        print(
            'Error allowing friend recommendations. Status code: ${response.statusCode}');
        throw Exception('Failed to allow friend recommendations');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> disallowFriendRecommendations(String friendId) async {
    try {
      String? token = await storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final url =
          Uri.parse('http://10.0.2.2:5001/friends/disallowfriend/$friendId');

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Friend recommendations disallowed successfully');
      } else {
        print(
            'Error disallowing friend recommendations. Status code: ${response.statusCode}');
        throw Exception('Failed to disallow friend recommendations');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<Friend>> fetchUserFriendsWithVisibility() async {
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
        Uri.parse('http://10.0.2.2:5001/friends/all'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body) as Map<String, dynamic>;
        var friends = data['friends'] as List;

        return friends.map<Friend>((json) {
          Friend user = Friend.fromJson(json);
          return user;
        }).toList();
      } else {
        throw Exception('Failed to load friends with visibility');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<String>> fetchAllowedFriendRecommendations() async {
    String? userId = await fetchUserId();
    List<String> allowedRecommendations = [];

    try {
      List<Friend> friends = await fetchUserFriends();

      for (Friend friend in friends) {
        if (friend.allowFriendRecommendations.contains(userId)) {
          allowedRecommendations.add(friend.id);
        }
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }

    return allowedRecommendations;
  }
}
