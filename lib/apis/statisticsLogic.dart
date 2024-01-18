import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../apis/AuthLogic.dart';
import '../models/artistModel.dart';

class StatisticsLogic {

  Future<Uint8List> songAnalysis(String type, DateTime? start, DateTime? end) async {
    String? token = await storage.read(key: 'token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String startDate = start != null ? DateFormat('yyyy-MM-dd').format(start) : '';
    String endDate = end != null ? DateFormat('yyyy-MM-dd').format(end) : '';

    String url = "http://10.0.2.2:5001/song-analysis?type=$type";
    if (startDate.isNotEmpty) {
      url += "&start=$startDate";
    }
    if (endDate.isNotEmpty) {
      url += "&end=$endDate";
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      String base64String = json.decode(response.body)['base64Image'];
      return _decodeBase64Image(base64String);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<List<Artist>> fetchArtists() async {
    String? token = await storage.read(key: 'token');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5001/artists'),
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

  Future<Uint8List> fetchArtistRatingAverage(List<String> artists) async {
    String? token = await storage.read(key: 'token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/mobile-artist-average-analysis'),
      headers: headers,
      body: json.encode({'artists': artists}),
    );

    if (response.statusCode == 200) {
      String base64String = json.decode(response.body)['base64Image'];
      print(base64String);
      return _decodeBase64Image(base64String);
    } else {
      throw Exception('Failed to fetch artist rating average');
    }
  }

  Future<Uint8List> fetchArtistsSongsCount(List<String> artists) async {
    String? token = await storage.read(key: 'token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/mobile-artist-songs-count-analysis'),
      headers: headers,
      body: json.encode({'artists': artists}),
    );

    if (response.statusCode == 200) {
      String base64String = json.decode(response.body)['base64Image'];
      print(base64String);
      return _decodeBase64Image(base64String);
    } else {
      throw Exception('Failed to fetch artist songs count');
    }
  }

  Future<Uint8List> fetchArtistsAverageRatingLastMonth(List<String> artists) async {
    String? token = await storage.read(key: 'token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/mobile-average-rating'),
      headers: headers,
      body: json.encode({'artists': artists}),
    );

    if (response.statusCode == 200) {
      String base64String = json.decode(response.body)['base64Image'];
      print(base64String);
      return _decodeBase64Image(base64String);
    } else {
      throw Exception('Failed to average artist ratings for the last month');
    }
  }



  Uint8List _decodeBase64Image(String base64String) {
    // Remove the prefix from the base64 string if it exists
    final RegExp regex = RegExp(r'data:image\/[a-zA-Z]+;base64,');
    String formattedBase64String = base64String.replaceFirst(regex, '');
    return base64Decode(formattedBase64String);
  }
}