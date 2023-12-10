import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srs_mobile/apis/MySongs_Logic.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({Key? key}) : super(key: key);

  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  late TextEditingController _artistController;
  late TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();
    _artistController = TextEditingController();
    _ratingController = TextEditingController();
  }

  Future<void> _exportData() async {
    try {
      String artist = _artistController.text;
      String rating = _ratingController.text;

      if (artist.isEmpty && rating.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artist or Rating is required.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (rating.isNotEmpty) {
        // Check if the rating is within the range [0, 5]
        double ratingValue = double.tryParse(rating) ?? -1;
        if (ratingValue < 0 || ratingValue > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rating should be between 0 and 5.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      List<dynamic> exportData = await SongService().fetchExportData(artist, rating);

      // Check if there's data to export
      if (exportData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data found to export.'),
            backgroundColor: Colors.yellow,
          ),
        );
        return;
      }

      // Print debug information
      print('Exported Data: $exportData');

      // Set the download directory

      // FOR ANDROID
      Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
      
      // TRY FOR IOS
      //Directory generalDownloadDir = await getApplicationDocumentsDirectory();

      // Generate a file name based on artist or rating
      String fileName;

      if (artist.isNotEmpty && rating.isNotEmpty) {
        // If both artist and rating are provided
        fileName = 'data_$artist-$rating.txt';
      } else if (artist.isNotEmpty) {
        // If only artist is provided
        fileName = 'artist_data-$artist.txt';
      } else if (rating.isNotEmpty) {
        // If only rating is provided
        fileName = 'rating_data-$rating.txt';
      } else {
        // This case shouldn't happen, but handle it just in case
        fileName = 'default_data.txt';
      }

      // Save the exported data to a JSON file in the external storage directory
      File exportFile = File('${generalDownloadDir.path}/$fileName');
      await exportFile.writeAsString(jsonEncode(exportData));
      
      // Print the location and name of the exported file
      print('Exported file location: ${generalDownloadDir.path}');
      print('Exported file name: $fileName');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully. File saved to External Storage.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error exporting data: $e');
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export data.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _artistController,
              decoration: const InputDecoration(labelText: 'Artist', labelStyle: TextStyle(color: Colors.green)),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating', labelStyle: TextStyle(color: Colors.green)),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _exportData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800], // Background color
                foregroundColor: Colors.white, // Text color
                side: const BorderSide(color: Colors.green, width: 2), // Border color
              ),
              child: const Text('Export Data', style: TextStyle(color: Colors.white, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}