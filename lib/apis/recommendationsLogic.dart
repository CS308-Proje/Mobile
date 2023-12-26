import 'package:http/http.dart' as http;
import 'dart:convert';
import '../apis/AuthLogic.dart';
import '../models/recommendationModel.dart';

enum RecommendationType { song, album, artist, spotify, temporal, friends }

Future<List<RecommendationModel>> fetchRecommendations(
    RecommendationType recType) async {
  try {
    String? tokenStorage = await storage.read(key: 'token');
    final headers = {
      'Authorization': 'Bearer $tokenStorage',
    };

    Uri url;
    switch (recType) {
      case RecommendationType.song:
        url = Uri.parse('http://10.0.2.2:5001/based-on-song-ratings');
        break;
      case RecommendationType.album:
        url = Uri.parse('http://10.0.2.2:5001/based-on-album-ratings');
        break;
      case RecommendationType.artist:
        url = Uri.parse('http://10.0.2.2:5001/based-on-artist-ratings');
        break;
      case RecommendationType.spotify:
        url = Uri.parse('http://10.0.2.2:5001/based-on-spotify');
        break;
      case RecommendationType.temporal:
        url = Uri.parse('http://10.0.2.2:5001/based-on-temporal');
        break;
      case RecommendationType.friends:
        url = Uri.parse('http://10.0.2.2:5001/based-on-friends');
        break;

      default:
        throw Exception('Invalid recommendation type');
    }

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success'] == true && data.containsKey('songs')) {
        List<dynamic> songsJson = data['songs'];
        return songsJson
            .map<RecommendationModel>(
                (json) => RecommendationModel.fromJson(json))
            .toList();
      } else if (data.containsKey('message')) {
        throw Exception(data['message']);
      } else {
        throw Exception('No data available for recommendations');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load songs - Response status not 200');
    }
  } catch (e) {
    print('Error fetching songs: $e');
    throw Exception('Failed to load songs');
  }
}
