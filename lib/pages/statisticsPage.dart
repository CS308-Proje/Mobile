<<<<<<< HEAD
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../apis/statisticsLogic.dart'; // Replace with the actual path
import '../models/artistModel.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  final StatisticsLogic _statisticsLogic = StatisticsLogic();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildImageFuture(String imageType) {
    return FutureBuilder<String>(
      future: _statisticsLogic.fetchBase64Image(imageType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final decodedBytes = base64Decode(snapshot.data!.split(',').last);
          return Padding(
            padding: const EdgeInsets.only(
                bottom: 150.0), // Space between each image

            child: Container(
              child: Image.memory(
                decodedBytes,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildChartsContent() {
    return Container(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildArtistFutureBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistFutureBuilder() {
    return FutureBuilder<List<Artist>>(
      future: _statisticsLogic.fetchArtists(),
      builder: (context, artistSnapshot) {
        if (artistSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        } else if (artistSnapshot.hasError) {
          return _buildErrorWidget(artistSnapshot.error);
        } else if (artistSnapshot.hasData) {
          return _buildSongCountFutureBuilder(artistSnapshot.data!);
        } else {
          return const Center(child: Text('No artists available'));
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildSongCountFutureBuilder(List<Artist> artists) {
    List<String> artistNames = artists.map((a) => a.artistName).toList();

    return FutureBuilder<List<int>>(
      future: _statisticsLogic.fetchArtistSongCounts(artistNames),
      builder: (context, songCountSnapshot) {
        if (songCountSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        } else if (songCountSnapshot.hasError) {
          return _buildErrorWidget(songCountSnapshot.error);
        } else if (songCountSnapshot.hasData) {
          List<int> songCounts = songCountSnapshot.data!;

          // Pair each artist with their song count and sort by song count
          var combined = List<MapEntry<Artist, int>>.generate(
            artists.length,
            (index) => MapEntry(artists[index], songCounts[index]),
          );
          combined.sort(
              (a, b) => b.value.compareTo(a.value)); // Sort in descending order

          // Take the top 5
          combined = combined.take(5).toList();

          // Update artists and songCounts lists to include only the top 5
          List<Artist> topArtists = combined.map((e) => e.key).toList();
          List<int> topSongCounts = combined.map((e) => e.value).toList();

          return _buildBarChart(topArtists, topSongCounts);
        } else {
          return const Center(child: Text('No song count data available'));
        }
      },
    );
  }

  Widget _buildBarChart(List<Artist> artists, List<int> songCounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Artists With Most Songs",
            style: TextStyle(
              color:
                  Color.fromARGB(255, 66, 66, 66), // Adjust the color as needed
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Center align the text horizontally
          ),
        ),
        SizedBox(
          height: 300, // Set a fixed height for the chart
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 300, // Set a fixed height for the chart
              decoration: BoxDecoration(
                color: Colors
                    .white70, // Set the background color of the plot area here
                borderRadius: BorderRadius.circular(
                    12), // Optional: if you want rounded corners
              ),
              child: BarChart(
                _buildBarChartData(artists, songCounts),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BarChartData _buildBarChartData(List<Artist> artists, List<int> songCounts) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: songCounts.reduce(max).toDouble(),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${artists[group.x.toInt()].artistName}\n',
              const TextStyle(color: Colors.white), // Title color
              children: <TextSpan>[
                TextSpan(
                  text: '${rod.y.toInt()} songs',
                  style: const TextStyle(
                    color: Colors.yellow, // Change the font color here
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          rotateAngle: 90, // Rotating the titles
          getTextStyles: (context, value) => const TextStyle(
              color: Color.fromARGB(255, 66, 66, 66),
              fontWeight: FontWeight.bold,
              fontSize: 16), // Smaller font size
          margin: 10,
          getTitles: (double value) {
            return artists[value.toInt()].artistName;
          },
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: _buildBarGroups(artists, songCounts),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
      List<Artist> artists, List<int> songCounts) {
    return songCounts.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            y: entry.value.toDouble(),
            width: 14, // Adjusted bar width
            colors: [Colors.lightBlueAccent], // Choose colors that stand out
            rodStackItems: [], // Set this to an empty list
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF171717), // Set the background color to black
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //title: const Text('Statistics'),
        backgroundColor: const Color(0xFF171717),
        title: TabBar(
          labelStyle: const TextStyle(color: Colors.white),
          indicatorColor: Colors.green,
          //indicatorPadding: EdgeInsets.symmetric(vertical: 5.0),
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorites',), //icon: Icon(Icons.star, color: Colors.green, size: 25.0,),
            Tab(text: 'Charts',), //icon: Icon(Icons.bar_chart, color: Colors.green, size: 25.0,),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            // Make the favorites tab scrollable
            child: Column(
              children: [
                buildImageFuture('song'),
                buildImageFuture('album'),
                buildImageFuture('artist'),
              ],
            ),
          ),
          SingleChildScrollView(
            // Make the charts tab scrollable
            child: Column(
              children: [
                buildChartsContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
=======
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/artistModel.dart';
import '../apis/statisticsLogic.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
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
    _tabController.addListener(_handleTabSelection);  // For resetting the state when the user switches between tabs, remove this line to avoid it
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
    _resetPageState();
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
      initialDate: isStart ? startDate : endDate,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF171717),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF171717),
        title: TabBar(
          labelStyle: const TextStyle(color: Colors.white),
          indicatorColor: Colors.green,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorites',),
            Tab(text: 'Charts',),
          ],
        ),
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
                    child: const Text('Fetch Image', style: TextStyle(color: Colors.white),),
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
>>>>>>> master
}