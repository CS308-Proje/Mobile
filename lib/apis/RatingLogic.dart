import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AuthLogic.dart';

enum RatingType { song, album, artist }

Future<void> rateItem(
    String itemId, RatingType ratingType, int ratingValue) async {
  Uri url;
  switch (ratingType) {
    case RatingType.song:
      url = Uri.parse('http://10.0.2.2:5001/rating/rateSong/$itemId');
      break;
    case RatingType.album:
      url = Uri.parse('http://10.0.2.2:5001/rating/rateAlbum/$itemId');
      break;
    case RatingType.artist:
      url = Uri.parse('http://10.0.2.2:5001/rating/rateArtist/$itemId');
      break;
    default:
      throw Exception('Invalid rating type');
  }

  String? token = await storage.read(key: 'token'); // Retrieve the token
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Include the token here
  };
  var body = json.encode({
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
