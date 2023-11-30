import 'package:flutter/material.dart';
import '../models/friendModel.dart';
import 'friend_add_tab.dart';
import 'friend_remove_tab.dart';

class AddRemoveFriendsPage extends StatefulWidget {
  final List<Friend> friends; // Add this parameter

  const AddRemoveFriendsPage({
    super.key,
    required this.friends, // Initialize it in the constructor
  });

  @override
  _AddRemoveFriendsPageState createState() => _AddRemoveFriendsPageState();
}

class _AddRemoveFriendsPageState extends State<AddRemoveFriendsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  TextEditingController addFriendController = TextEditingController();

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

  void _filterItems(String keyword) {
    // Implement your filtering logic here
  }

  void _addFriend() {
    // Implement the logic to add a friend using addFriendController.text
    //String newFriendUsername = addFriendController.text;
    // Perform the add friend operation and update the UI accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0.0,
        toolbarHeight: 60.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 35),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Add',
              icon: Icon(
                Icons.person_add,
                color: Colors.green,
                size: 20.0,
              ),
            ), // Tab label for "Add" tab
            Tab(
              text: 'Remove',
              icon: Icon(
                Icons.person_remove,
                color: Colors.green,
                size: 20.0,
              ),
            ), // Tab label for "Remove" tab
          ],
          indicatorColor: Colors.green,
        ),
      ),
      body: Container(
        color: const Color(0xFF171717),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Content for "Add" tab
            AddFriendTab(
              addFriendController: addFriendController,
              onAddFriendPressed: _addFriend,
            ),
            // Content for "Remove" tab
            RemoveFriendTab(
              searchController: searchController,
              friends: widget.friends, // Pass the friends list
            ),
          ],
        ),
      ),
    );
  }
}
