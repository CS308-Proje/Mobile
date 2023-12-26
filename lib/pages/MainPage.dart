// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'recommendations.dart';
import '../pages/friends_page.dart';
import '../pages/add_remove_page.dart';
import '../pages/statisticsPage.dart';
import '../pages/main_page_content.dart';
import '../apis/MyFriends_Logic.dart';
import '../models/invitationModel.dart';
import '../models/friendModel.dart';

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
      const RecommendationsPage(), // Index 0 - Recommendations page
      const AddRemovePage(),       // Index 1 - Add-Remove page
      const MainPageContent(),     // Index 2 - Home page content
      const FriendsPage(),         // Index 3 - Friends page
      const StatisticsPage(),      // Index 4 - Statistics Page
    ]);
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showVisibilitySettings(BuildContext context) async {
    List<Friend> friends = await MyFriendsLogic().fetchUserFriends();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text('Should friends see music recommendations?', style: TextStyle(color: Colors.green),),
          content: SingleChildScrollView(
            child: ListBody(
              children: friends.map((Friend friend) {
                return _VisibilitySetting(username: friend.username, friendId: friend.id);
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(fontSize: 20.0),),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) async {
    List<Invitation> invitations = await MyFriendsLogic().fetchUserInvitations();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[800],
          child: ListView.separated(
            itemCount: invitations.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.white,
              thickness: 1.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              Invitation invitation = invitations[index];

              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Friend Request from ${invitation.userId}',
                        style: const TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        // Accept friend request
                        await MyFriendsLogic().updateInvitationStatus(invitation.id, 'accepted');
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        // Reject friend request
                        await MyFriendsLogic().updateInvitationStatus(invitation.id, 'rejected');
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Handle tapping on the notification if needed
                  // You can navigate to a specific page or take any action
                },
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
        backgroundColor: const Color(0xFF171717),
        elevation: 0.0,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => _showVisibilitySettings(context),
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
  final String username;
  final String friendId;
  const _VisibilitySetting({required this.username, required this.friendId});

  @override
  _VisibilitySettingState createState() => _VisibilitySettingState();
}

class _VisibilitySettingState extends State<_VisibilitySetting> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.username, style: const TextStyle(color: Colors.white, fontSize: 20.0),),
      value: _isVisible,
      //tileColor: Colors.white,
      onChanged: (bool value) async {
        setState(() {
          _isVisible = value;
        });

        try {
          if (_isVisible) {
            await MyFriendsLogic().allowFriendRecommendations(widget.friendId);
          } else {
            await MyFriendsLogic().disallowFriendRecommendations(widget.friendId);
          }
        } catch (e) {
          // Handle errors as needed
          print('Error: $e');
        }
      },
      activeColor: Colors.green,
    );
  }
}