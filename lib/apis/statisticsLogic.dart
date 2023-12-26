import 'package:http/http.dart' as http;
import 'dart:convert';
import '../apis/AuthLogic.dart'; // If you need to use the auth token
import '../models/artistModel.dart';

class StatisticsLogic {
  Future<String> fetchBase64Image(String type) async {
    String? token =
        await storage.read(key: 'token'); // Retrieve the token, if needed
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include the token here, if needed
    };

    final response = await http.get(
      Uri.parse('http://localhost:5001/song-analysis?type=$type'),
      headers: headers, // Include headers if your endpoint requires them
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true && data.containsKey('data')) {
        return data['data'];
      } else {
        print('Data not found or success is false');
        throw Exception('Failed to load image data');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<List<Artist>> fetchArtists() async {
    String? token = await storage.read(key: 'token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://localhost:5001/artists'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var artistsList = data['artists'] as List;
      return artistsList.map<Artist>((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }

  Future<List<int>> fetchArtistSongCounts(List<String> artists) async {
    String? token = await storage.read(key: 'token'); // Retrieve the token
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include the token here
    };

    final response = await http.post(
      Uri.parse('http://localhost:5001/artist-songs-count-analysis'),
      headers: headers,
      body: json.encode({'artists': artists}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true && data.containsKey('data')) {
        return List<int>.from(data['data']);
      } else {
        throw Exception('Failed to load artist song counts');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<List<double>> fetchArtistAverageRatings(List<String> artists) async {
    String? token = await storage.read(key: 'token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('http://localhost:5001/artist-average-analysis'),
      headers: headers,
      body: json.encode({'artists': artists}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true && data.containsKey('data')) {
        return List<double>.from(data['data']);
      } else {
        throw Exception('Failed to load artist average ratings');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
