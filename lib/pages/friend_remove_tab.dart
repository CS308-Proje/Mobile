import 'package:flutter/material.dart';
import '../models/friendModel.dart';

class RemoveFriendTab extends StatefulWidget {
  final TextEditingController searchController;
  final List<Friend> friends;

  const RemoveFriendTab({
    Key? key,
    required this.searchController,
    required this.friends,
  }) : super(key: key);

  @override
  _RemoveFriendTabState createState() => _RemoveFriendTabState();
}

class _RemoveFriendTabState extends State<RemoveFriendTab> {
  List<Friend> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = widget.friends; // Initialize filteredFriends with all friends initially
  }

  void _showRemoveFriendDialog(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal',
              style: TextStyle(color: Colors.green)),
          content: Text('Are you sure you want to remove "${friend.username}" from friends?',
              style: const TextStyle(color: Colors.white, fontSize: 20.0)),
          backgroundColor: Colors.grey[800],
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  //_clearSearch();
                }),
            TextButton(
              child: const Text('Remove',
                  style: TextStyle(color: Colors.red, fontSize: 20.0)),
              onPressed: () {
                //_removeItem(item); // Remove the item
                Navigator.of(context).pop();
                //_clearSearch();
              },
            ),
          ],
        );
      },
    );
  }

  void _filterItems(String keyword) {
    setState(() {
      filteredFriends = widget.friends.where((friend) {
        return friend.name.toLowerCase().contains(keyword.toLowerCase()) ||
            friend.username.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: widget.searchController,
            style: const TextStyle(color: Colors.green),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 3.0,
                ),
              ),
              suffixIcon: const Icon(Icons.search, color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
            ),
            onChanged: _filterItems,
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemCount: filteredFriends.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white), // Add a white divider between friends
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return GestureDetector(
                  onTap: () {
                    _showRemoveFriendDialog(context, friend);
                  },
                  child: ListTile(
                    title: Text(friend.name, style: const TextStyle(color: Colors.green)), // Apply white text color to friend's name
                    subtitle: Text(friend.username, style: const TextStyle(color: Colors.white)), // Apply white text color to friend's username
                    // Add more information about the friend here
                  ),                  
                );
              },
            ),
        ),
      ],
    );
  }
}
