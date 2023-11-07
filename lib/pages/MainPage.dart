import 'package:flutter/material.dart';

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
        itemCount: 5, // example data count
        itemBuilder: (context, index) => _MusicCard(),
      ),
    );
  }
}

class _MusicCard extends StatelessWidget {
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
          Text('Song Title', style: TextStyle(color: Colors.white)),
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
