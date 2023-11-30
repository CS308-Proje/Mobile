import 'package:flutter/material.dart';
import '../models/friendModel.dart';
import '../apis/MyFriends_Logic.dart';
import 'add_remove_friends_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String? userId;
  List<Friend> friends = [];
  List<Friend> filteredFriends = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch the user's ID when the page initializes
  }

  Future<void> _fetchUserId() async {
    userId = await storage.read(key: 'userId'); // Fetch the user's ID from storage
    if (userId != null) {
      _fetchUserFriends(userId!); // Call _fetchUserFriends with the userId when available
    }
  }

  Future<void> _fetchUserFriends(String userId) async {
    try {
      final userFriends = await MyFriendsLogic().fetchUserFriends(userId);

      setState(() {
        friends = userFriends;
        filteredFriends = userFriends;
      });
    } catch (error) {
      // Handle errors if necessary
    }
  }

  Future<void> _addRemoveFriendsNavigation(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddRemoveFriendsPage(friends: friends), // Pass the friends list
    ));

    if (result != null && result is List<Friend>) {
      setState(() {
        friends = result;
        filteredFriends = result;
      });
    }
  }

  void _filterItems(String keyword) {
    setState(() {
      filteredFriends = friends.where((friend) {
        return friend.name.toLowerCase().contains(keyword.toLowerCase()) ||
            friend.username.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          const SizedBox(height: 80.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.green, width: 3.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.green, width: 3.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.white, width: 3.0),
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
              ),
              onChanged: (String value) {
                _filterItems(value);
              },
            ),
          ),
          const SizedBox(height: 50.0,),
          friends.isEmpty
            ? const Center(
              child: Text('No friends yet.', style: TextStyle(color: Colors.white, fontSize: 20.0),),
            )
          : Expanded(
            child: ListView.separated(
              itemCount: filteredFriends.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white), // Add a white divider between friends
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return ListTile(
                  title: Text(friend.name, style: const TextStyle(color: Colors.green)), // Apply white text color to friend's name
                  subtitle: Text(friend.username, style: const TextStyle(color: Colors.white)), // Apply white text color to friend's username
                  // Add more information about the friend here
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top:20.0, right: 15.0),
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
            border: Border.all(
              color: Colors.green,
              width: 3.0,
            ),
          ),
          child: FloatingActionButton(
            onPressed: () {
              _addRemoveFriendsNavigation(context);
            },
            backgroundColor: Colors.grey[800],
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                  'assets/plus-slash-minus.png', // Replace with the correct asset path
                  width: 32.0, // Adjust the width and height as needed
                  height: 32.0,
                  color: Colors.white, // Optional: Set the color of the image
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
