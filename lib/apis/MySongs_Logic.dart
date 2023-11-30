import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/songModel.dart'; // Import the Song model
// secure storage
import 'AuthLogic.dart';

class SongService {
  Future<List<Song>> fetchSongs() async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization':
          'Bearer $tokenStorage', // Replace with your actual access token
    };

    final response = await http.get(Uri.parse('http://10.0.2.2:5000/songs'),
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

  Future<bool> addSongInfo(String songName, String mainArtist, List<String> featuringArtists, String albumName) async {

    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization': 'Bearer $tokenStorage', // Replace with your actual access token
      'Content-Type': 'application/json',
    };

    final songData = {
      'songName': songName,
      'mainArtistName': mainArtist,
      'featuringArtistNames': featuringArtists,
      'albumName': albumName,
    };

    final data = jsonEncode(songData);


    // Check if the song is already in the database
    List<Song> existingSongs = await fetchSongs();

    bool songExists = existingSongs.any((song) =>
      song.songName == songName &&
      song.mainArtistName == mainArtist &&
      song.albumName == albumName);

    if (songExists) {
      print('Song already exists in the database. Skipping addition.');
      return false; // Return false to indicate that the song was not added
    } 
    
    else {
      final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/songs'),
      headers: headers,
      body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Song added successfully');
        print('Response body: ${response.body}');
        return true;
      } else {
        print('Failed to add the song. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    }
  }

  Future<List<int>> addSongFile(File file) async {
    String content = await file.readAsString();
    List<dynamic> songData = jsonDecode(content);

    int addedCount = 0;
    int failedCount = 0;

    for (var song in songData) { 
      print('Song Name: ${song['songName']}');
      print('Album Name: ${song['albumName']}');
      print('Main Artist Name: ${song['mainArtistName']}');
      List<String> featuringArtists = song['featuringArtistNames'] != null
          ? List<String>.from(song['featuringArtistNames'])
          : [];
      print('Featuring Artist Names: ${featuringArtists.join(', ')}');
      print('------------------------');

      bool isAdded = await SongService().addSongInfo(
        song['songName'], 
        song['mainArtistName'], 
        featuringArtists, 
        song['albumName']
      );

      if (isAdded) {
        addedCount++;
      } else {
        failedCount++;
        print('Could not add a song: ${json.encode(songData)}');
      }
    }
    
    List<int> SF = [addedCount, failedCount];
    return SF;
  }

  Future<bool> deleteSongById(String songId) async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization': 'Bearer $tokenStorage', // Replace with your actual access token
    };

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/songs/$songId'), // Use the song ID in the URL
        headers: headers,
      );

      final responseBody = json.decode(response.body);
      final deletedSongName = responseBody['song']['songName'];

      if (response.statusCode == 200) {
      print('The song $deletedSongName deleted successfully');
      return true;
      } else {
        print('Failed to delete the song $deletedSongName. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> deleteArtistById(String artistId) async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization': 'Bearer $tokenStorage', // Replace with your actual access token
    };

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/artists/$artistId'), // Use the song ID in the URL
        headers: headers,
      );

      final responseBody = json.decode(response.body);
      final deletedArtistName = responseBody['song']['mainArtistName'];

      if (response.statusCode == 200) {
      print('The artist $deletedArtistName deleted successfully');
      return true;
      } else {
        print('Failed to delete the artist $deletedArtistName. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> deleteAlbumById(String albumId) async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization': 'Bearer $tokenStorage', // Replace with your actual access token
    };

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/albums/$albumId'), // Use the song ID in the URL
        headers: headers,
      );

      final responseBody = json.decode(response.body);
      final deletedAlbumName = responseBody['song']['albumName'];

      if (response.statusCode == 200) {
      print('The album $deletedAlbumName deleted successfully');
      return true;
      } else {
        print('Failed to delete the album $deletedAlbumName. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
