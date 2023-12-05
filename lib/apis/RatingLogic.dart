import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AuthLogic.dart';

Future<void> rateSong(String songId, String userId, int ratingValue) async {
  var url = Uri.parse('http://10.0.2.2:5000/rating/rateSong');
  String? token = await storage.read(key: 'token'); // Retrieve the token

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Include the token here
  };
  var body = json.encode({
    'songId': songId,
    'userId': userId,
    'ratingValue': ratingValue,
  });

  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Rating submitted successfully');
    } else {
      print('Failed to submit rating: ${response.statusCode}');
      // Additional logging for debugging
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while sending rating: $e');
  }
}
