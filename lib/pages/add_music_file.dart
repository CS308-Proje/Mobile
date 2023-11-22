// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../apis/MySongs_Logic.dart';

class AddMusicFile extends StatefulWidget {
  const AddMusicFile({super.key});

  @override
  _AddMusicFileState createState() => _AddMusicFileState();
}

class _AddMusicFileState extends State<AddMusicFile> {

  File? file;
  Future<void> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      List<int> resultCounts = await SongService().addSongFile(file!);

      int addedCount = resultCounts[0];
      int failedCount = resultCounts[1];

      if (failedCount == 0) {
        // All songs were added successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: Text('Added $addedCount songs successfully.'),
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
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            );
          },
        );
      } else {
        // Some songs failed to add
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Could not add $failedCount songs.'),
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
    } 

    // If the file could not be opened
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the file.'),
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