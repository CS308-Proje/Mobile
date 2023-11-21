import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/songModel.dart'; // Import the Song model
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // secure storage
import 'AuthLogic.dart';

class SongService {
  Future<List<Song>> fetchSongs() async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization':
          'Bearer ${tokenStorage}', // Replace with your actual access token
    };

    final response = await http.get(Uri.parse('http://localhost:5001/songs'),
        headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var songs = data['songs'] as List;

      return songs.map<Song>((json) => Song.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load songs');
    }
  }
}
