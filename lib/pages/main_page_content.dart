import 'dart:async';
import 'package:flutter/material.dart';
import '../models/songModel.dart'; // Update this import according to your model structure
import '../models/albumModel.dart'; // You need to create this
import '../models/artistModel.dart'; // You need to create this
import '../apis/MySongs_Logic.dart'; // Update this import according to your service structure
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../apis/RatingLogic.dart';
import '../apis/AuthLogic.dart';

// Enum for different data types
enum DataType { songs, albums, artists }

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
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const _SectionHeader(title: 'Songs', route: '/songs'),
            const _MusicList(dataType: DataType.songs),

            const _SectionHeader(title: 'Albums', route: '/albums'),
            const _MusicList(dataType: DataType.albums),

            const _SectionHeader(title: 'Artists', route: '/artists'),
            const _MusicList(dataType: DataType.artists),
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
  final DataType dataType;

  const _MusicList({Key? key, required this.dataType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songService =
        SongService(); // Assuming this service can handle different data types

    Future<List<dynamic>> fetchData() {
      switch (dataType) {
        case DataType.songs:
          return songService.fetchSongs();
        case DataType.albums:
          return songService.fetchAlbums(); // Implement this method
        case DataType.artists:
          return songService.fetchArtists(); // Implement this method
        default:
          throw Exception('Invalid data type');
      }
    }

    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return _MusicCard(item: item);
              },
            ),
          );
        }
      },
    );
  }
}

class _MusicCard extends StatefulWidget {
  final dynamic item;

  const _MusicCard({Key? key, required this.item}) : super(key: key);

  @override
  __MusicCardState createState() => __MusicCardState();
}

class __MusicCardState extends State<_MusicCard> {
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the _rating based on the item's ratingValue
    if (widget.item is Song) {
      _rating = (widget.item as Song).ratingValue?.toDouble() ?? 0.0;
    } else if (widget.item is Album) {
      _rating = (widget.item as Album).ratingValue?.toDouble() ?? 0.0;
    } else if (widget.item is Artist) {
      _rating = (widget.item as Artist).ratingValue?.toDouble() ?? 0.0;
    } else {
      _rating = 0.0; // Default value if the item type is not recognized
    }
  }

  Future<void> _updateRating(double rating) async {
    String? userId = await storage.read(key: 'userId');
    if (userId != null) {
      try {
        if (widget.item is Song) {
          // Rate a song
          await rateItem(widget.item.id, RatingType.song, rating.toInt());
        } else if (widget.item is Album) {
          // Rate an album
          await rateItem(widget.item.id, RatingType.album, rating.toInt());
        } else if (widget.item is Artist) {
          // Rate an artist
          await rateItem(widget.item.id, RatingType.artist, rating.toInt());
        }
      } catch (e) {
        print('Error in rating: $e');
      }
    } else {
      print('User ID not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the type of the item and extract the relevant data for display
    String title, imageUrl;
    if (widget.item is Song) {
      Song song = widget.item as Song;
      title = song.songName;
      imageUrl = song.albumImg;
    } else if (widget.item is Album) {
      Album album = widget.item as Album;
      title = album.name;
      imageUrl = album.albumImg;
    } else if (widget.item is Artist) {
      Artist artist = widget.item as Artist;
      title = artist.artistName;
      imageUrl = artist.artistImg;
    } else {
      // Fallback for unknown item type
      return const SizedBox.shrink();
    }

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
          Image.network(imageUrl, height: 80.0),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
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
                _updateRating(rating);
              }
            },
          ),
        ],
      ),
    );
  }
}
