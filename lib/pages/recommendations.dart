import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({Key? key}) : super(key: key);

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

  Widget _buildHorizontalList() {
    // Dummy items for the horizontal list
    List<Widget> items = List.generate(10, (index) {
      return Container(
        width: 130.0,
        margin: const EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[800],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            // Replace with actual data
            FlutterLogo(size: 80.0),
            Text(
              'Item',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });

    return SizedBox(
      height: 180.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Recommendations'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSectionTitle('Based on Songs'),
              _buildHorizontalList(),
              _buildSectionTitle('Based on Artists'),
              _buildHorizontalList(),
              _buildSectionTitle('Based on Albums'),
              _buildHorizontalList(),
              _buildSectionTitle('Based on Spotify'),
              _buildHorizontalList(),
              _buildSectionTitle('Based on Friends'),
              _buildHorizontalList(),
              _buildSectionTitle('Based on Temporal Values'),
              _buildHorizontalList(),
            ],
          ),
        ),
      ),
    );
  }
}
