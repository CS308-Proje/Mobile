import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srs_mobile/apis/MySongs_Logic.dart';

enum ExportType { CSV, JSON, TXT }

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  late TextEditingController _artistController;
  late TextEditingController _ratingController;
  ExportType _selectedExportType = ExportType.JSON; // Default export type

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

      String fileName;

      switch (_selectedExportType) {
        case ExportType.CSV:
          fileName = 'data_$artist-$rating.csv';
          break;
        case ExportType.JSON:
          fileName = 'data_$artist-$rating.json';
          break;
        case ExportType.TXT:
          fileName = 'data_$artist-$rating.txt';
          break;
      }

      // Setting the download directory
      Directory generalDownloadDir;

      // For Android
      if (Platform.isAndroid) {
        generalDownloadDir = Directory('/storage/emulated/0/Download');
      } 
      // For iOS
      else if (Platform.isIOS) {
        generalDownloadDir = await getApplicationDocumentsDirectory();
      } 
      // For other platforms
      else {
        generalDownloadDir = Directory.current;
      }

      // Generate a file name based on artist or rating
      File exportFile = File('${generalDownloadDir.path}/$fileName');
      await exportFile.writeAsString(_encodeData(exportData, _selectedExportType));

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export data. Data with requested parameters could not be found.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _encodeData(List<dynamic> data, ExportType exportType) {
    switch (exportType) {
      case ExportType.CSV:
        return _encodeDataToCSV(data);
      case ExportType.JSON:
        return jsonEncode(data);
      case ExportType.TXT:
        return _encodeDataToTXT(data);
    }
  }

  String _encodeDataToCSV(List<dynamic> data) {
    List<List<dynamic>> rows = [];

    rows.add(data.first.keys.toList());

    for (var entry in data) {
      rows.add(entry.values.toList());
    }

    return const ListToCsvConverter().convert(rows);
  }

  String _encodeDataToTXT(List<dynamic> data) {
    String jsonString = jsonEncode(data);
    return jsonString.replaceAll(',', ',\n');
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
            const SizedBox(height: 20),
            DropdownButton<ExportType>(
              value: _selectedExportType,
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              iconEnabledColor: Colors.green,
              onChanged: (ExportType? newValue) {
                setState(() {
                  _selectedExportType = newValue!;
                });
              },
              items: 
                ExportType.values.map<DropdownMenuItem<ExportType>>((ExportType value) {
                  return DropdownMenuItem<ExportType>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _exportData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.green, width: 2),
              ),
              child: const Text('Export Data', style: TextStyle(color: Colors.white, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}