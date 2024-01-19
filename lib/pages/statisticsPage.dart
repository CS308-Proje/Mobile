import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/artistModel.dart';
import '../apis/statisticsLogic.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with SingleTickerProviderStateMixin {
  final StatisticsLogic _statisticsLogic = StatisticsLogic();
  late TabController _tabController;

  String? selectedType = 'song';
  List<String> selectedArtists = [];
  DateTime? startDate;
  DateTime? endDate;
  Uint8List? imageData;
  Uint8List? artistRatingImage;
  Uint8List? artistSongsCountImage;
  Uint8List? artistRatingLastMonthImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _resetPageState();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _resetPageState() {
    setState(() {
      selectedType = 'song';
      selectedArtists = [];
      startDate = null;
      endDate = null;
      imageData = null;
      artistRatingImage = null;
      artistSongsCountImage = null;
      artistRatingLastMonthImage = null;
    });
  }

  void _showDatePicker(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Color(0xFF171717),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != (isStart ? startDate : endDate)) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _removeArtist(String artistName) {
    setState(() {
      selectedArtists.remove(artistName);
    });
  }

  // Method to handle sharing of analysis
  void _shareAnalysis(Uint8List? data, String analysisType) async {
    if (data != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/$analysisType.png').create();
      await imagePath.writeAsBytes(data);

      Share.shareFiles([imagePath.path], text: 'Check out my $analysisType analysis!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No $analysisType analysis to share.')));
    }
  }

  void _showSharePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171717),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.white),
              title: const Text('Share Song Analysis', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                _shareAnalysis(imageData, 'song');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text('Share Artist Rating Analysis', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                _shareAnalysis(artistRatingImage, 'artist rating');
              },
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF171717),
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorites'),
            Tab(text: 'Charts'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showSharePopup(context),
            tooltip: 'Share Analysis',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedType,
                          dropdownColor: Colors.grey[800],
                          style: const TextStyle(color: Colors.white, fontSize: 18.0),
                          items: <String>['song', 'album', 'artist']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue;
                            });
                          },
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          iconEnabledColor: Colors.green,
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                            onPressed: () => _showDatePicker(context, true),
                            child: const Text("Start Date", style: TextStyle(color: Colors.white)),
                          ),
                          Text(
                            startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : "Date not set",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                            onPressed: () => _showDatePicker(context, false),
                            child: const Text('End Date', style: TextStyle(color: Colors.white)),
                          ),
                          Text(
                            endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : "Date not set",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        Uint8List fetchedImage = await _statisticsLogic.songAnalysis(
                          selectedType!, 
                          startDate, 
                          endDate
                        );
                        setState(() {
                          imageData = fetchedImage;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                      }
                    },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                    child: const Text('Fetch Analysis', style: TextStyle(color: Colors.white),),
                  ),
                ),
                // Display image here
                if (imageData != null) Image.memory(imageData!),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Artist>>(
                  future: _statisticsLogic.fetchArtists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return DropdownButton<String>(
                          value: null,
                          hint: Text("Select Artists", style: TextStyle(color: Colors.white),),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          iconEnabledColor: Colors.green,
                          dropdownColor: Colors.grey[800],
                          items: snapshot.data!.map((Artist artist) {
                            return DropdownMenuItem<String>(
                              value: artist.artistName,
                              child: Text(artist.artistName, style: TextStyle(color: Colors.white),),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedArtists.add(newValue);
                              });
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                    }
                    return CircularProgressIndicator();
                  },
                ),
                Wrap(
                  spacing: 6.0,
                  children: selectedArtists.map((artist) => Chip(
                    label: Text(artist),
                    onDeleted: () => _removeArtist(artist),
                    deleteIcon: Icon(Icons.cancel),
                  )).toList(),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                  onPressed: () async {
                    try {
                      Uint8List fetchedImage = await _statisticsLogic.fetchArtistRatingAverage(selectedArtists);
                      setState(() {
                        artistRatingImage = fetchedImage;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  child: Text('Fetch Artist Rating Average', style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                  onPressed: () async {
                    try {
                      Uint8List fetchedImage = await _statisticsLogic.fetchArtistsSongsCount(selectedArtists);
                      setState(() {
                        artistSongsCountImage = fetchedImage;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  child: Text('Fetch Artist Songs Count', style: TextStyle(color: Colors.white),),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
                  onPressed: () async {
                    try {
                      Uint8List fetchedImage = await _statisticsLogic.fetchArtistsAverageRatingLastMonth(selectedArtists);
                      setState(() {
                        artistRatingLastMonthImage = fetchedImage;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  child: Text('Fetch Artist Last Month Average Rating', style: TextStyle(color: Colors.white),),
                ),
                if (artistRatingImage != null) Image.memory(artistRatingImage!),
                if (artistSongsCountImage != null) Image.memory(artistSongsCountImage!),
                if (artistRatingLastMonthImage != null) Image.memory(artistRatingLastMonthImage!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
