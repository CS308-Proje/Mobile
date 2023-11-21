import 'dart:async';
import 'package:flutter/material.dart';
import '../models/songModel.dart';
import '../apis/MySongs_Logic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../apis/RatingLogic.dart';
import '../apis/AuthLogic.dart';

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Liked Songs Section
            const _SectionHeader(title: 'Liked Songs', route: '/liked_songs'),
            const _MusicList(),

            // Recommendations Section
            const _SectionHeader(
                title: 'Recommendations', route: '/recommendations'),
            const _MusicList(),

            // Additional sections can be added here
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String route;

  const _SectionHeader({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, route),
            child: const Text(
              'See All',
              style: TextStyle(color: Colors.green, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicList extends StatelessWidget {
  const _MusicList();

  @override
  Widget build(BuildContext context) {
    final songService = SongService();

    return FutureBuilder<List<Song>>(
      future: songService.fetchSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return _MusicCard(song: snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }
}

class _MusicCard extends StatefulWidget {
  final Song song;

  const _MusicCard({Key? key, required this.song}) : super(key: key);

  @override
  __MusicCardState createState() => __MusicCardState();
}

class __MusicCardState extends State<_MusicCard> {
  double _rating = 0;
  double _previousRating = 0;

  Future<void> _updateRating(double rating) async {
    String? userId = await storage.read(key: 'userId');
    if (userId != null) {
      rateSong(widget.song.id, userId, rating.toInt());
    } else {
      print('User ID not found');
      // Handle user ID not found
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Image.network(widget.song.albumImg,
              height: 80.0), // Display album image
          Text(widget.song.songName,
              style: const TextStyle(color: Colors.white)), // Display song name
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 16.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              if (_rating != rating) {
                setState(() {
                  _rating = rating;
                });
                _updateRating(rating); // Call the new method for rating update
              }
            },
          ),
        ],
      ),
    );
  }
}
