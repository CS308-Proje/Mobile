// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import '../apis/MySongs_Logic.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/spotifyModel.dart';

class AddSongPage extends StatelessWidget {
  const AddSongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF171717),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF171717),
          title: const TabBar(
            labelStyle: TextStyle(color: Colors.white),
            labelColor: Colors.white,
            indicatorColor: Colors.green,
            tabs: [
              Tab(
                text: 'Info',
              ),
              Tab(
                text: 'File',
              ),
              Tab(
                text: 'DB',
              ),
              Tab(
                text: 'Spotify',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddSongInfoForm(),
            AddSongFileForm(),
            TransferSongsForm(),
            AddSongSpotifyForm()
          ],
        ),
      ),
    );
  }
}

class AddSongInfoForm extends StatefulWidget {
  const AddSongInfoForm({super.key});

  @override
  _AddSongInfoFormState createState() => _AddSongInfoFormState();
}

class _AddSongInfoFormState extends State<AddSongInfoForm> {
  final TextEditingController _songNameController = TextEditingController();
  final TextEditingController _mainArtistController = TextEditingController();
  final TextEditingController _featuringArtistsController =
      TextEditingController();
  final TextEditingController _albumNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          TextField(
            controller: _songNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Song Name',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _mainArtistController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Main Artist',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _featuringArtistsController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Featuring Artists',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _albumNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Album Name',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 25.0,
          ),
          SizedBox(
            width: 180.0,
            height: 45.0,
            child: ElevatedButton(
              onPressed: () async {
                String songName = _songNameController.text.trim();
                String mainArtist = _mainArtistController.text.trim();
                String featuringArtists =
                    _featuringArtistsController.text.trim();
                String albumName = _albumNameController.text.trim();

                if (songName.isEmpty ||
                    mainArtist.isEmpty ||
                    albumName.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Error'),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('A necessary field is empty.'),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                List<String> featuringArtistsList =
                    featuringArtists.split(',').map((e) => e.trim()).toList();

                bool isAdded = await SongService().addSongInfo(
                  songName,
                  mainArtist,
                  featuringArtistsList,
                  albumName,
                );

                if (isAdded) {
                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Song added successfully!'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.green, width: 2.5),
                        ),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.green),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        backgroundColor: Colors.grey[800],
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green, // Color for text
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK',
                                style: TextStyle(fontSize: 20.0)),
                          ),
                        ],
                      );
                    },
                  );
                  _songNameController.clear();
                  _mainArtistController.clear();
                  _featuringArtistsController.clear();
                  _albumNameController.clear();
                } else {
                  // Show error dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Failed to add song.'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.red),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        backgroundColor: Colors.grey[800],
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK',
                                style: TextStyle(fontSize: 20.0)),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(
                    color: Colors.green,
                    width: 3.0,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.green),
                    SizedBox(width: 10.0),
                    Text('Add Song',
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddSongFileForm extends StatefulWidget {
  const AddSongFileForm({super.key});

  @override
  _AddSongFileFormState createState() => _AddSongFileFormState();
}

class _AddSongFileFormState extends State<AddSongFileForm> {
  final TextEditingController _fileController = TextEditingController();
  String? _selectedFileName;
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 180.0),
          ElevatedButton(
            onPressed: () async {
              // Call file picker to allow the user to select a .txt file
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['txt', 'json'],
              );

              if (result != null && result.files.isNotEmpty) {
                String filePath = result.files.first.path!;
                String fileName = result.files.first.name;

                // Update the _fileController with the selected file path
                setState(() {
                  _fileController.text = filePath;
                  _selectedFileName = fileName;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green,
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Select a file',
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                ],
              ),
            ),
          ),
          if (_selectedFileName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Selected File: $_selectedFileName',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              if (_fileController.text.isEmpty) {
                // Show dialog for empty file path
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[800],
                      title: const Text('Error'),
                      titleTextStyle:
                          const TextStyle(fontSize: 25, color: Colors.red),
                      content:
                          const Text('Please select a file before uploading.'),
                      contentTextStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        side: BorderSide(color: Colors.red, width: 2.5),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK',
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              // Call the method to handle adding songs from file with progress
              await _uploadFileWithProgress(File(_fileController.text));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green,
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, color: Colors.green),
                  SizedBox(width: 10.0),
                  Text('Upload File',
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                ],
              ),
            ),
          ),
          if (_uploadProgress > 0.0 && _uploadProgress < 1.0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _uploadFileWithProgress(File file) async {
    SongService songService = SongService();

    try {
      // Initialize progress callback
      onProgress(double progress) {
        setState(() {
          _uploadProgress = progress;
        });
      }

      // Call the method to handle adding songs from file with progress
      List<int> result =
          await songService.addSongFileWithProgress(file, onProgress);

      int addedCount = result[0];
      int failedCount = result[1];

      // Show result dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: const Text('Upload Result'),
            content: Text(
                '$addedCount songs added successfully.\n\n$failedCount songs failed to add.'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.green, width: 2.5),
            ),
            titleTextStyle: const TextStyle(fontSize: 25, color: Colors.green),
            contentTextStyle:
                const TextStyle(fontSize: 20, color: Colors.white),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20.0, color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle the error
      print('Error uploading file: $e');
    } finally {
      setState(() {
        _uploadProgress = 0.0;
        _selectedFileName = null; // Clear the selected file name
      });
    }
  }
}

class TransferSongsForm extends StatefulWidget {
  const TransferSongsForm({super.key});

  @override
  _TransferSongsFormState createState() => _TransferSongsFormState();
}

class _TransferSongsFormState extends State<TransferSongsForm> {
  final TextEditingController _databaseURIController = TextEditingController();
  final TextEditingController _databaseNameController = TextEditingController();
  final TextEditingController _collectionNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          TextField(
            controller: _databaseURIController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Database URI',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _databaseNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Database Name',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: _collectionNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Collection Name',
                labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 220.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                // Retrieve values from controllers
                String databaseURI = _databaseURIController.text.trim();
                String databaseName = _databaseNameController.text.trim();
                String collectionName = _collectionNameController.text.trim();

                // Check if any field is empty
                if (databaseURI.isEmpty ||
                    databaseName.isEmpty ||
                    collectionName.isEmpty) {
                  // Show dialog for empty fields
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Error'),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('All fields are required.'),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                // Call the method to handle transferring songs
                bool transferResult = await SongService()
                    .transferSongs(databaseURI, databaseName, collectionName);

                // Display result dialog based on transferResult
                if (transferResult) {
                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Success'),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.green),
                        content: const Text('Songs transferred successfully.'),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.green, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.green)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show error dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Error'),
                        titleTextStyle:
                            const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('Failed to transfer songs.'),
                        contentTextStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(
                    color: Colors.green,
                    width: 3.0,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.green),
                    SizedBox(width: 10.0),
                    Text('Transfer Songs',
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Make sure to import your SongService and Song model

class AddSongSpotifyForm extends StatefulWidget {
  const AddSongSpotifyForm({super.key});

  @override
  _AddSongSpotifyFormState createState() => _AddSongSpotifyFormState();
}

class _AddSongSpotifyFormState extends State<AddSongSpotifyForm> {
  TextEditingController searchController = TextEditingController();
  List<Spotify> spotifyResults = []; // List to hold Song objects
  final SongService songService = SongService(); // Instance of your SongService

  void searchSpotify(String query) async {
    if (query.isEmpty) {
      // Optionally handle empty query case
      print('Search query is empty');
      return;
    }

    try {
      var results = await songService.fetchSpotify(query);
      setState(() {
        spotifyResults = results;
      });
      if (results.isEmpty) {
        print('No results found');
      }
    } catch (e) {
      print('Error fetching songs from Spotify: $e');
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search on Spotify...',
              hintStyle: const TextStyle(color: Colors.white60),
              fillColor: Colors.grey[800],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  searchSpotify(searchController.text);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: spotifyResults.length,
            itemBuilder: (context, index) {
              final song = spotifyResults[index];
              return ListTile(
                leading: Image.network(song.albumImg, width: 50, height: 50,
                    errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.music_note, color: Colors.white));
                }),
                title: Text(song.songName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(song.mainArtistName,
                    style: const TextStyle(color: Colors.white70)),
                tileColor: Colors.grey[850],
                onTap: () => _showAddSongConfirmationDialog(song),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddSongConfirmationDialog(Spotify song) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800], // Dark background for the dialog
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20), // White title text
          contentTextStyle: const TextStyle(
              color: Colors.white70), // Lighter text for the content
          title: const Text('Add Song to Database'),
          content: Text(
              'Do you want to add "${song.songName}" by ${song.mainArtistName} to the database?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style:
                      TextStyle(color: Colors.red)), // Customized button text
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add',
                  style:
                      TextStyle(color: Colors.green)), // Customized button text
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await songService.saveSpotifySongToDb(song);
                final snackBar = SnackBar(
                  content: Text(success
                      ? 'Song added successfully'
                      : 'Failed to add song'),
                  backgroundColor: success
                      ? Colors.green
                      : Colors.red, // Change color based on success or failure
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
