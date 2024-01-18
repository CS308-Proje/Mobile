import 'package:flutter/material.dart';
import '../apis/recommendationsLogic.dart';
import '../models/recommendationModel.dart';
import '../apis/MySongs_Logic.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  TextEditingController searchController = TextEditingController();

  Future<void> _refreshData() async {
    setState(() {
      // This will trigger the rebuild of the page with new data
    });
  }

  Future<void> _showAddSongDialog(RecommendationModel recommendation) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          contentTextStyle:
              const TextStyle(fontSize: 20, color: Colors.white60),
          titleTextStyle: const TextStyle(fontSize: 25, color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          title: const Text('Add Song'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Do you want to add "${recommendation.songName}" to your songs?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18, // Adjust the font size here
                  color: Colors.red, // Adjust the text color here
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18, // Adjust the font size here
                  color: Colors.blue, // Adjust the text color here
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _addSong(recommendation); // Add the song
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addSong(RecommendationModel recommendation) async {
    // Create an instance of SongService
    SongService songService = SongService();

    // Call addSongInfo using the instance
    bool added = await songService.addSongInfo(
      recommendation.songName,
      recommendation.mainArtistName,
      [], // Assuming no featuring artists for simplicity
      recommendation.albumName,
    );

    if (added) {
      // Show a success message or update state as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${recommendation.songName} added successfully')),
      );
    } else {
      // Show an error message or handle the failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add ${recommendation.songName}')),
      );
    }
  }

  Widget _buildRecommendationsList(
      Future<List<RecommendationModel>> recommendationsFuture) {
    return FutureBuilder<List<RecommendationModel>>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        // Check for connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error if any occurred while fetching data
          return Text('Error: ${snapshot.error.toString()}',
              style: const TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show a message if there are no recommendations
          return const Text('No recommendations available',
              style: TextStyle(color: Colors.white));
        }

        // Data is available and not empty, build the list
        return SizedBox(
          height: 180.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var recommendation = snapshot.data![index];
              return GestureDetector(
                onTap: () => _showAddSongDialog(recommendation),
                child: Container(
                  width: 130.0,
                  margin: const EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[800],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(recommendation.albumImg, height: 80.0),
                      Text(
                        recommendation.songName,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        recommendation.mainArtistName,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      // Additional information from RecommendationModel can be displayed here if needed
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionTitle('Based on Songs'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.song)),

                // BASED ON ALBUMS
                _buildSectionTitle('Based on Albums'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.album)),

                //BASED ON ARTISTS
                _buildSectionTitle('Based on Arists'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.artist)),

                // BASED ON SPOTIFY
                _buildSectionTitle('Based on Spotify'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.spotify)),

                // BASED ON TEMPORAL
                _buildSectionTitle('Based on Temporal'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.temporal)),

                // BASED ON FRIENDS
                _buildSectionTitle('Based on Friends'),
                _buildRecommendationsList(
                    fetchRecommendations(RecommendationType.friends)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
