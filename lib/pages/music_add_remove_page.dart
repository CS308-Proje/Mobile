import 'dart:io';
import 'dart:convert';
import 'music_remove_page.dart';
import 'add_music_options_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddRemovePage extends StatelessWidget {
  const AddRemovePage({super.key});

  void _showAddMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add Music',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.grey[700],
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => _showAddSongForm(context),
              child: const Text('Enter Song Information',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
            SimpleDialogOption(
              onPressed: () => pickAndReadFile(),
              child: const Text('Select a TXT File',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _showAddDatabaseForm(context);
              },
              child: const Text('Enter Database URI',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[800],
                side: const BorderSide(width: 2.0, color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fixedSize: const Size(150, 150),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddMusicOptionsPage()),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 60.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Add',
                    style: TextStyle(fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[800],
                side: const BorderSide(width: 2.0, color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fixedSize: const Size(150, 150),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MusicRemovePage()),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_circle_outline, size: 60),
                  SizedBox(height: 10.0),
                  Text(
                    'Remove',
                    style: TextStyle(fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Song Form
void _showAddSongForm(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String songName = '';
  String albumName = '';
  String mainArtistName = '';
  List<String> featuringArtistNames = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Song Information',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
        backgroundColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // rounded edge
        ),
        content: Theme(
          data: ThemeData(
            primaryColor:
                Colors.green, // Color for underline of the input when focused
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(
                  color: Colors.blue), // Color for the label when focused
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color:
                        Colors.green), // Color for the underline when focused
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Song Name',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      songName = value ?? '';
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'This field is required'
                          : null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Album Name',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      albumName = value ?? '';
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'This field is required'
                          : null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Main Artist Name',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      mainArtistName = value ?? '';
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'This field is required'
                          : null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Featuring Artist Names',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        featuringArtistNames = value
                            .split(',')
                            .map((name) => name.trim())
                            .where((name) => name.isNotEmpty)
                            .toList();
                      } else {
                        featuringArtistNames = [];
                      }
                    },
                    validator: (String? value) {
                      // Allow empty field
                      if (value == null || value.isEmpty) {
                        return null;
                      }

                      if (!RegExp(r'^\s*[\w\s]+(?:,\s*[\w\s]+)*\s*$')
                          .hasMatch(value)) {
                        return 'Enter artist names in array format (e.g., Artist1, Artist2)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // Color for text
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(fontSize: 20.0)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, // Color for text
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                // Printing song information
                print('Song Name: $songName');
                print('Album Name: $albumName');
                print('Main Artist Name: $mainArtistName');
                print(
                    'Featuring Artist Names: ${featuringArtistNames.join(', ')}');

                // Add song to database here
                print('Song added successfully.');
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add', style: TextStyle(fontSize: 20.0)),
          ),
        ],
      );
    },
  );
}

// Adding songs through a .txt file
void pickAndReadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    List<dynamic> songData = jsonDecode(content);

    for (var song in songData) {
      print('Song Name: ${song['songName']}');
      print('Album Name: ${song['albumName']}');
      print('Main Artist Name: ${song['mainArtistName']}');
      List<String> featuringArtists =
          List<String>.from(song['featuringArtistNames']);
      print('Featuring Artist Names: ${featuringArtists.join(', ')}');
    }
  } else {
    print("No file selected!");
  }
}

// Enter Database URI
void _showAddDatabaseForm(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String databaseUri = '';
  String databaseName = '';
  String collectionName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Database Information',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
        backgroundColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Theme(
          data: ThemeData(
            primaryColor: Colors.green,
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.blue),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Database URI',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      databaseUri = value ?? '';
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      if (Uri.tryParse(value) == null) {
                        return 'Enter a valid URI';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Database Name',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      databaseName = value ?? '';
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'This field is required'
                          : null;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Collection Name',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                    onSaved: (String? value) {
                      collectionName = value ?? '';
                    },
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'This field is required'
                          : null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(fontSize: 20.0)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                // Use the database information for adding songs
                print('Database URI: $databaseUri');
                print('Database Name: $databaseName');
                print('Collection Name: $collectionName');
                print('Database information saved successfully.');
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 20.0)),
          ),
        ],
      );
    },
  );
}

Future<void> addSongToDatabase(String uri, String dbName, String collectionName,
    Map<String, dynamic> songData) async {
  final url = Uri.parse(
      '$uri/$dbName/$collectionName/add-song'); // Adjust based on your API endpoint
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(songData),
  );

  if (response.statusCode == 200) {
    print('Song added successfully');
  } else {
    print('Failed to add song');
  }
}
