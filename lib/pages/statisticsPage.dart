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
}