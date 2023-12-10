// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import '../apis/MySongs_Logic.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddSongPage extends StatelessWidget {
  const AddSongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                text: 'Add via Info',
              ),
              Tab(
                text: 'Add via File',
              ),Tab(
                text: 'Add via DB',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddSongInfoForm(),
            AddSongFileForm(),
            TransferSongsForm(),
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
  final TextEditingController _featuringArtistsController = TextEditingController();
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
            decoration: const InputDecoration(labelText: 'Song Name', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _mainArtistController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Main Artist', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _featuringArtistsController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Featuring Artists', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _albumNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Album Name', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 25.0,),
          SizedBox(
            width: 180.0,
            height: 45.0,
            child: ElevatedButton(
              onPressed: () async {
                String songName = _songNameController.text.trim();
                String mainArtist = _mainArtistController.text.trim();
                String featuringArtists = _featuringArtistsController.text.trim();
                String albumName = _albumNameController.text.trim();

                if (songName.isEmpty || mainArtist.isEmpty || albumName.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Error'),
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('A necessary field is empty.'),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                List<String> featuringArtistsList = featuringArtists.split(',').map((e) => e.trim()).toList();

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
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.green),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        backgroundColor: Colors.grey[800],
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green, // Color for text
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0)),
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
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        backgroundColor: Colors.grey[800],
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0)),
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
                    Text('Add Song', style: TextStyle(color: Colors.white, fontSize: 18.0)),
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
                  Text('Select a file', style: TextStyle(color: Colors.white, fontSize: 18.0)),
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
                      titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
                      content: const Text('Please select a file before uploading.'),
                      contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        side: BorderSide(color: Colors.red, width: 2.5),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.red)),
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
                  Text('Upload File', style: TextStyle(color: Colors.white, fontSize: 18.0)),
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
      List<int> result = await songService.addSongFileWithProgress(file, onProgress);

      int addedCount = result[0];
      int failedCount = result[1];

      // Show result dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: const Text('Upload Result'),
            content: Text('$addedCount songs added successfully.\n\n$failedCount songs failed to add.'),
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.green, width: 2.5),
            ),
            titleTextStyle: const TextStyle(fontSize: 25, color: Colors.green),
            contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.green),),
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
  final TextEditingController _collectionNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          TextField(
            controller: _databaseURIController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Database URI', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _databaseNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Database Name', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _collectionNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Collection Name', labelStyle: TextStyle(color: Colors.green)),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 220.0,
            height: 50.0,
            child: ElevatedButton (
              onPressed: () async {
                // Retrieve values from controllers
                String databaseURI = _databaseURIController.text.trim();
                String databaseName = _databaseNameController.text.trim();
                String collectionName = _collectionNameController.text.trim();

                // Check if any field is empty
                if (databaseURI.isEmpty || databaseName.isEmpty || collectionName.isEmpty) {
                  // Show dialog for empty fields
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Error'),
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('All fields are required.'),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                // Call the method to handle transferring songs
                bool transferResult = await SongService().transferSongs(databaseURI, databaseName, collectionName);

                // Display result dialog based on transferResult
                if (transferResult) {
                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[800],
                        title: const Text('Success'),
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.green),
                        content: const Text('Songs transferred successfully.'),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.green, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.green)),
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
                        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
                        content: const Text('Failed to transfer songs.'),
                        contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          side: BorderSide(color: Colors.red, width: 2.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.red)),
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
                    Text('Transfer Songs', style: TextStyle(color: Colors.white, fontSize: 18.0)),
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