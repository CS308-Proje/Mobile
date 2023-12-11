import 'package:flutter/material.dart';
import 'package:srs_mobile/pages/recommendations.dart';
import '../pages/friends_page.dart';
import '../pages/add_remove_page.dart';
import '../pages/main_page_content.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  Widget _placeholderWidget() {
    return const Center(
      child: Text('Page under construction',
          style: TextStyle(color: Colors.white, fontSize: 30.0)),
    );
  }

  // List of widgets to call when a tab is selected
  final List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      const RecommendationsPage(), // Index 0
      const AddRemovePage(), // Index 1 - Add-Remove page
      const MainPageContent(), // Index 2 - Home page content
      const FriendsPage(), // Index 3 - Friends page
      _placeholderWidget(), // Index 4
    ]);
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  
  void _showVisibilitySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: const Text('Should Friends See Music Recommendations?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                _VisibilitySetting(user: 'user1'),
                _VisibilitySetting(user: 'user2'),
                _VisibilitySetting(user: 'user3'),
                _VisibilitySetting(user: 'user4'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              style: TextButton.styleFrom(primary: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).appBarTheme.backgroundColor, 
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Notification ${index + 1}'),
                onTap: () {}, 
              );
            },
          ),
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/friends'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        currentIndex:
            _selectedIndex, // This is used to update the selected item
        onTap: _onBottomNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommendations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add-Remove',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
      ),
    );
  }
}
class _VisibilitySetting extends StatefulWidget {
  final String user;

  const _VisibilitySetting({Key? key, required this.user}) : super(key: key);

  @override
  _VisibilitySettingState createState() => _VisibilitySettingState();
}

class _VisibilitySettingState extends State<_VisibilitySetting> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.user),
      value: _isVisible,
      onChanged: (bool value) {
        setState(() {
          _isVisible = value;
        });
      },
      activeColor: Colors.green,
    );
  }
}
