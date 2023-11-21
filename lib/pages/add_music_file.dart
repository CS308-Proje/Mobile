import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class AddMusicFile extends StatefulWidget {
  const AddMusicFile({super.key});

  @override
  _AddMusicFileState createState() => _AddMusicFileState();
}

class _AddMusicFileState extends State<AddMusicFile> {
  void pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        String content = await file.readAsString();
        List<dynamic> songData = jsonDecode(content);

        for (var song in songData) {
          print('Song Name: ${song['songName']}');
          print('Album Name: ${song['albumName']}');
          print('Main Artist Name: ${song['mainArtistName']}');
          List<String> featuringArtists = song['featuringArtistNames'] != null
              ? List<String>.from(song['featuringArtistNames'])
              : [];
          print('Featuring Artist Names: ${featuringArtists.join(', ')}');
          print('------------------------');
        }
      } catch (e) {
        print('Error reading file or invalid JSON format: $e');
      }
    } else {
      print("No file selected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 60.0,
        leading: 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 35),
            onPressed: () => Navigator.of(context).pop(),
          ),
        centerTitle: true,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
      ),
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: ElevatedButton(
          onPressed: pickAndReadFile,
          style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: const BorderSide(color: Colors.green, width: 3.0),
          ),
        ),
          child: const Text('Select File', style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}