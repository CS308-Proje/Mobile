import 'dart:io';
import 'dart:convert';
import 'package:srs_mobile/models/spotifyModel.dart';

import 'AuthLogic.dart'; // Secure storage
import 'package:http/http.dart' as http;
import '../models/songModel.dart'; // Import the Song model
import '../models/artistModel.dart'; // Import the Artist model
import '../models/albumModel.dart'; // Import the Album model

class SongService {
  Future<List<Song>> fetchSongs() async {
    String? tokenStorage = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $tokenStorage',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5001/songs'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var songs = data['songs'] as List;

      return songs.map<Song>((json) => Song.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Artist>> fetchArtists() async {
    String? tokenStorage = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $tokenStorage',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5001/artists'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var artists = data['artists'] as List;

      return artists.map<Artist>((json) => Artist.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load artists');
    }
  }

  Future<List<Album>> fetchAlbums() async {
    String? tokenStorage = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $tokenStorage',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5001/albums'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var albums = data['albums'] as List;

      return albums.map<Album>((json) => Album.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load albums');
    }
  }

  Future<bool> addSongInfo(String songName, String mainArtist,
      List<String> featuringArtists, String albumName) async {
    String? tokenStorage = await storage.read(key: 'token'); // Await the Future

    final headers = {
      'Authorization':
          'Bearer $tokenStorage', // Replace with your actual access token
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
      return false;
    } else {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/songs'),
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

  Future<List<int>> addSongFileWithProgress(
      File file, void Function(double)? onProgress) async {
    try {
      String content = await file.readAsString();
      List<dynamic> songs = jsonDecode(content);

      int addedCount = 0;
      int failedCount = 0;

      for (var i = 0; i < songs.length; i++) {
        try {
          // Extract song information
          var songData = songs[i];
          String songName = songData['songName'];
          String mainArtist = songData['mainArtistName'];
          List<String> featuringArtists =
              List<String>.from(songData['featuringArtistNames']);
          String albumName = songData['albumName'];

          bool isAdded = await addSongInfo(
              songName, mainArtist, featuringArtists, albumName);

          if (isAdded) {
            addedCount++;
          } else {
            failedCount++;
          }
        } catch (e) {
          print('Error processing song data: $e');
          failedCount++;
        }

        if (onProgress != null) {
          double progress = (i + 1) / songs.length;
          onProgress(progress);
        }
      }

      return [addedCount, failedCount];
    } catch (e) {
      print('Error reading file content: $e');
      return [0, 0];
    }
  }

  Future<bool> transferSongs(
      String databaseURI, String databaseName, String collectionName) async {
    try {
      String? tokenStorage = await storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $tokenStorage',
        'Content-Type': 'application/json',
      };

      final transferData = {
        'databaseURI': databaseURI,
        'databaseName': databaseName,
        'collectionName': collectionName,
      };

      final data = jsonEncode(transferData);

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/transfer-songs'),
        headers: headers,
        body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Songs transferred successfully');
        print('Response body: ${response.body}');
        return true;
      } else {
        print('Failed to transfer songs. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error transferring songs: $e');
      return false;
    }
  }

  // Remove song by ID
  Future<void> removeSong(String songId) async {
    try {
      String? tokenStorage = await storage.read(key: 'token');
      final headers = {
        'Authorization': 'Bearer $tokenStorage',
        'Content-Type': 'application/json',
      };

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5001/songs/$songId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Song removed successfully.');
      } else {
        print('Failed to remove song. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error removing song: $e');
    }
  }

  // Remove album by ID
  Future<void> removeAlbum(String albumId) async {
    try {
      String? tokenStorage = await storage.read(key: 'token');
      final headers = {
        'Authorization': 'Bearer $tokenStorage',
        'Content-Type': 'application/json', //
      };

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5001/albums/$albumId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Album removed successfully.');
      } else {
        print('Failed to remove album. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error removing album: $e');
    }
  }

  // Remove artist by ID
  Future<void> removeArtist(String artistId) async {
    try {
      String? tokenStorage = await storage.read(key: 'token');
      final headers = {
        'Authorization': 'Bearer $tokenStorage',
        'Content-Type': 'application/json', //
      };

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5001/artists/$artistId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Artist removed successfully.');
      } else {
        print('Failed to remove artist. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error removing artist: $e');
    }
  }

  Future<List<dynamic>> fetchExportData(String artist, String rating) async {
    try {
      String? tokenStorage = await storage.read(key: 'token');

      final headers = {
        'Authorization': 'Bearer $tokenStorage',
        'Content-Type': 'application/json',
      };

      Uri uri = Uri.parse('http://10.0.2.2:5001/export')
          .replace(queryParameters: {'artist': artist, 'rating': rating});

      final response = await http.post(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to export data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to export data');
      }
    } catch (e) {
      print('Error exporting data: $e');
      throw Exception('Failed to export data');
    }
  }

  Future<List<Spotify>> fetchSpotify(String songName) async {
    String? tokenStorage = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $tokenStorage',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse(
        'http://10.0.2.2:5001/directly-from-spotify?songName=$songName');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var songsArray = data['songsArray'] as List;

      return songsArray.map<Spotify>((json) => Spotify.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to load songs from Spotify');
    }
  }

  Future<bool> saveSpotifySongToDb(Spotify spotify) async {
    String? tokenStorage = await storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $tokenStorage',
      'Content-Type': 'application/json',
    };

    final songData = {
      'songName': spotify.songName,
      'mainArtistName': spotify.mainArtistName,
      'albumName': spotify.albumName,
      'albumImg': spotify.albumImg,
      'featuringArtistNames': spotify.featuring,
      'popularity': spotify.popularity,
      'duration_ms': spotify.duration,
      'release_date': spotify.relaseDate,
      'artistId': spotify.artistId,
    };

    final data = jsonEncode(songData);

    // Check if the song is already in the database
    List<Song> existingSongs = await fetchSongs();

    bool songExists = existingSongs.any((existingSong) =>
        existingSong.songName == spotify.songName &&
        existingSong.mainArtistName == spotify.mainArtistName &&
        existingSong.albumName == spotify.albumName);

    if (songExists) {
      print('Song already exists in the database. Skipping addition.');
      return false;
    } else {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/spotify-search-to-db'),
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
}
