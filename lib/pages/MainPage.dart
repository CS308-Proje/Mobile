import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/friends'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Liked Songs
              _SectionHeader(title: 'Liked Songs', route: '/Liked Songs'),
              _MusicList(),

              // Recommendations
              _SectionHeader(
                  title: 'Recommendations', route: '/recommendations'),
              _MusicList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomBar(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String route;

  _SectionHeader({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, route),
            child: Text('See All',
                style: TextStyle(color: Colors.green, fontSize: 16.0)),
          ),
        ],
      ),
    );
  }
}
class _MusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, 
        itemBuilder: (context, index) {
          return _MusicCard(
            songTitle: 'Song Title $index',
          );
        },
      ),
    );
  }
}

class _MusicCard extends StatefulWidget {
  final String songTitle;

  _MusicCard({required this.songTitle});

  @override
  __MusicCardState createState() => __MusicCardState();
}
class __MusicCardState extends State<_MusicCard> {
  double _rating = 0;
  double _previousRating = 0;

  void _sendRating() {
    // API'ye puanlama isteği   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.0,
      margin: EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[800],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.music_note, size: 50.0, color: Colors.white),
          Text(widget.songTitle, style: TextStyle(color: Colors.white)),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 16.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              if (_rating != 0 && _rating != rating) {
                
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[800], 
                      title: Text('Change Rating', style: TextStyle(color: Colors.white)),
                      content: Text('Are you sure you want to change your rating?', style: TextStyle(color: Colors.white)),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel', style: TextStyle(color: Colors.green)),
                          onPressed: () {
                            Navigator.pop(context); 
                            },
                        ),
                        TextButton(
                          child: Text('OK', style: TextStyle(color: Colors.green)),
                          onPressed: () {
                            setState(() {
                              _rating = rating;
                            });
                            Navigator.pop(context);
                            _sendRating(); 
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  _previousRating = _rating; 
                  _rating = rating;
                });
                _sendRating(); 
              }
            },
          ),
        ],
      ),
    );
  }
}




class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Add this line
      backgroundColor: Colors.black,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Liked Songs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statistics',
        ),
      ],
    );
  }
}
