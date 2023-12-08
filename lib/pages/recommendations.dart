import 'package:flutter/material.dart';
import '../apis/recommendationsLogic.dart';
import '../models/recommendationModel.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({Key? key}) : super(key: key);

  Widget _buildRecommendationsList(
      Future<List<RecommendationModel>> recommendationsFuture) {
    return FutureBuilder<List<RecommendationModel>>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.toString()}',
              style: const TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No recommendations available',
              style: TextStyle(color: Colors.white));
        }

        return SizedBox(
          height: 180.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var recommendation = snapshot.data![index];
              return Container(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // BASED ON SONGS
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
    );
  }
}
