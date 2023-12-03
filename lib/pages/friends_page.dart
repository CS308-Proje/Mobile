import 'package:flutter/material.dart';
import '../models/friendModel.dart';
import '../apis/MyFriends_Logic.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userId;
  List<Friend> friends = [];
  List<Friend> filteredFriends = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController addFriendController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    userId = await storage.read(key: 'userId');
    if (userId != null) {
      _fetchUserFriends(userId!);
    }
  }

  Future<void> _fetchUserFriends(String userId) async {
    final userFriends = await MyFriendsLogic().fetchUserFriends(userId);

    setState(() {
      friends = userFriends;
      filteredFriends = userFriends;
    });
  }

  void _filterItems(String keyword) {
    setState(() {
      filteredFriends = friends.where((friend) {
        return friend.name.toLowerCase().contains(keyword.toLowerCase()) ||
            friend.username.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  void _addFriend() async {
    if (userId != null) {
      final enteredFriendId = addFriendController.text;
      if (enteredFriendId.isEmpty){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('The ID field should not be empty.'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                side: BorderSide(color: Colors.red, width: 2.5),
              ),
              titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
              contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
              backgroundColor: Colors.grey[800],
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    addFriendController.clear();
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            );
          },
        );
      } else {
        if (friends.any((friend) => friend.id == enteredFriendId)) {
        // Show a dialog indicating that the friend already exists
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('The friend with ID "$enteredFriendId" is already in your friends list.'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                side: BorderSide(color: Colors.red, width: 2.5),
              ),
              titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
              contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
              backgroundColor: Colors.grey[800],
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    addFriendController.clear();
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            );
          },
        );
      } else {
          await MyFriendsLogic().addFriendById(userId!, addFriendController.text);
          _fetchUserFriends(userId!); // Reload friends after adding
          addFriendController.clear();
          FocusScope.of(context).unfocus();
        }
      }
    }
  }

  void _removeFriend(String friendId) async {
    if (userId != null) {
      await MyFriendsLogic().removeFriendById(userId!, friendId);
      _fetchUserFriends(userId!); // Reload friends after removing
      setState(() {
        filteredFriends = filteredFriends.where((friend) => friend.id != friendId).toList();
      });
      searchController.clear();
      searchFocusNode.unfocus();
    }
  }

  void _showRemoveFriendDialog(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal', style: TextStyle(color: Colors.green)),
          content: Text('Are you sure you want to remove "${friend.username}" from friends?', style: const TextStyle(color: Colors.white, fontSize: 20.0)),
          backgroundColor: Colors.grey[800],
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 20.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 20.0)),
              onPressed: () {
                _removeFriend(friend.id); // Call the removal function
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
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
                    ),
                    Tab(
                      text: 'Remove',
                      icon: Icon(
                        Icons.person_remove,
                        color: Colors.green,
                        size: 20.0,
                      ),
                    ),
                  ],
                  indicatorColor: Colors.green,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Content for "Add" tab
                      Column(
                        children: [
                          const SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: addFriendController,
                              style: const TextStyle(color: Colors.green),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[800],
                                hintText: 'Enter friend\'s ID...',
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
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180.0,
                            height: 45.0,
                            child: ElevatedButton(
                              onPressed: _addFriend,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green, backgroundColor: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(
                                    color: Colors.green,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_add, color: Colors.green),
                                    SizedBox(width: 10.0),
                                    Text('Add Friend', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                                  ],
                                ),
                              ),
                            ), 
                          ),
                          const SizedBox(height: 20.0),
                          friends.isEmpty
                              ? const Center(
                                  //const SizedBox(height:20.0);
                                  child: Column(children: [
                                    SizedBox(height: 150.0,),
                                    Text('No friends yet.', style: TextStyle(color: Colors.white, fontSize: 22.0),)
                                  ],
                                ),
                              )
                              : Expanded(
                                  child: ListView.separated(
                                    itemCount: friends.length,
                                    separatorBuilder: (context, index) => const Divider(color: Colors.white),
                                    itemBuilder: (context, index) {
                                      final friend = friends[index];
                                      return ListTile(
                                        title: Text(friend.name, style: const TextStyle(color: Colors.green)),
                                        subtitle: Text(friend.username, style: const TextStyle(color: Colors.white)),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),             
                      // Content for "Remove" tab
                      Column(
                        children: [
                          const SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocusNode, // Assign the focus node
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
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                              ),
                              onChanged: (String value) {
                                _filterItems(value);
                              },
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Expanded(
                            child: ListView.separated(
                              itemCount: filteredFriends.length,
                              separatorBuilder: (context, index) => const Divider(color: Colors.white),
                              itemBuilder: (context, index) {
                                final friend = filteredFriends[index];
                                return GestureDetector(
                                  onTap: () {
                                    _showRemoveFriendDialog(context, friend);
                                  },
                                  child: ListTile(
                                    title: Text(friend.name, style: const TextStyle(color: Colors.green)),
                                    subtitle: Text(friend.username, style: const TextStyle(color: Colors.white)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}