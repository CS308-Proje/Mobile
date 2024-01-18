import 'package:flutter/material.dart';
import '../models/friendModel.dart';
import '../models/invitationModel.dart';
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
  List<Invitation> invitations = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController addFriendController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchUserId();
    _fetchUserFriends();
    _fetchUserInvitations();
    super.initState();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0: // Add tab
          break;
        case 1: // Invitations tab
          _fetchUserInvitations();
          break;
        case 2: // Remove tab
          _fetchUserFriends();
          break;
      }
    }
  }

  Future<void> _fetchUserId() async {
    userId = await storage.read(key: 'userId');
    if (userId != null) {
      _fetchUserFriends();
    }
  }

  Future<void> _fetchUserFriends() async {
    final userFriends = await MyFriendsLogic().fetchUserFriends();

    setState(() {
      friends = userFriends;
      filteredFriends = userFriends;
    });
  }

  Future<void> _fetchUserInvitations() async {
    try {
      List<Invitation> fetchedInvitations =
          await MyFriendsLogic().fetchUserInvitations();

      setState(() {
        invitations = fetchedInvitations;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _acceptFriendRequest(Invitation invitation) async {
    try {
      await MyFriendsLogic().updateInvitationStatus(invitation.id, 'accepted');

      // Fetch updated data before navigating to FriendsPage
      await _fetchUserFriends();
      await _fetchUserInvitations();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend request accepted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  Future<void> _rejectFriendRequest(Invitation invitation) async {
    try {
      await MyFriendsLogic().updateInvitationStatus(invitation.id, 'rejected');

      // Fetch updated data before navigating to FriendsPage
      await _fetchUserFriends();
      await _fetchUserInvitations();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend request rejected successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error rejecting friend request: $e');
    }
  }

  Future<void> _sendFriendRequest() async {
    if (userId != null) {
      final enteredFriendId = addFriendController.text;

      // Check if the entered friend ID is the same as the current user's ID
      if (enteredFriendId == userId) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('You cannot send a friend request to yourself.'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                side: BorderSide(color: Colors.red, width: 2.5),
              ),
              titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
              contentTextStyle:
                  const TextStyle(fontSize: 20, color: Colors.white),
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
      } else if (enteredFriendId.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('The ID field should not be empty.'),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                side: BorderSide(color: Colors.red, width: 2.5),
              ),
              titleTextStyle: const TextStyle(fontSize: 25, color: Colors.red),
              contentTextStyle:
                  const TextStyle(fontSize: 20, color: Colors.white),
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
        // Check if the entered target is already a friend
        if (friends.any((friend) => friend.id == enteredFriendId)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    const Text('You are already friends with this person.'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  side: BorderSide(color: Colors.red, width: 2.5),
                ),
                titleTextStyle:
                    const TextStyle(fontSize: 25, color: Colors.red),
                contentTextStyle:
                    const TextStyle(fontSize: 20, color: Colors.white),
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
          // Check if the user already sent an invitation to the target user
          if (invitations.any(
              (invitation) => invitation.targetUserId == enteredFriendId)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'You have already sent a friend request to this person.'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    side: BorderSide(color: Colors.red, width: 2.5),
                  ),
                  titleTextStyle:
                      const TextStyle(fontSize: 25, color: Colors.red),
                  contentTextStyle:
                      const TextStyle(fontSize: 20, color: Colors.white),
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
            try {
              await MyFriendsLogic()
                  .sendFriendRequest(userId!, enteredFriendId);
              print('Friend request sent successfully');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Friend request sent successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              print('Error sending friend request: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error sending friend request!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
          addFriendController.clear();
          FocusScope.of(context).unfocus();
        }
      }
    }
  }

  void _removeFriend(String friendId) async {
    if (userId != null) {
      await MyFriendsLogic().removeFriendById(friendId);
      _fetchUserFriends();
      setState(() {
        filteredFriends =
            filteredFriends.where((friend) => friend.id != friendId).toList();
        friends = friends.where((friend) => friend.id != friendId).toList();
      });
      searchController.clear();
      searchFocusNode.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend removed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _filterItems(String keyword) {
    setState(() {
      filteredFriends = friends
          .where((friend) =>
              friend.name.toLowerCase().contains(keyword.toLowerCase()) ||
              friend.username.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _showRemoveFriendDialog(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal',
              style: TextStyle(color: Colors.green)),
          content: Text(
              'Are you sure you want to remove "${friend.username}" from friends?',
              style: const TextStyle(color: Colors.white, fontSize: 20.0)),
          backgroundColor: Colors.grey[800],
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 20.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove',
                  style: TextStyle(color: Colors.red, fontSize: 20.0)),
              onPressed: () {
                _removeFriend(friend.id);
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
                  labelStyle:
                      const TextStyle(fontSize: 18.0, color: Colors.white),
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
                      text: 'Invitations',
                      icon: Icon(
                        Icons.mail,
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
                          const SizedBox(height: 200.0),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: TextField(
                              controller: addFriendController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[800],
                                hintText:
                                    'Enter an ID here to send a friend request...',
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
                            width: 280.0,
                            height: 45.0,
                            child: ElevatedButton(
                              onPressed: _sendFriendRequest,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green,
                                backgroundColor: Colors.grey[800],
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
                                    Icon(Icons.send_rounded,
                                        color: Colors.green),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Send Friend Request',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Content for "Invitations" tab
                      Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Expanded(
                            child: invitations.isNotEmpty
                                ? ListView.builder(
                                    itemCount: invitations.length,
                                    itemBuilder: (context, index) {
                                      final invitation = invitations[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 20.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            'Friend request from ${invitation.userId}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Status: ${invitation.status}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () =>
                                                    _acceptFriendRequest(
                                                        invitation),
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _rejectFriendRequest(
                                                        invitation),
                                                icon: const Icon(
                                                  Icons.clear,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      'No friend invitations.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      // Content for "Remove" tab
                      Column(
                        children: [
                          const SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextField(
                              controller: searchController,
                              focusNode:
                                  searchFocusNode, // Assign the focus node
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[800],
                                hintText: 'Search...',
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 3.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 3.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3.0),
                                ),
                                suffixIcon: const Icon(Icons.search,
                                    color: Colors.white),
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
                              separatorBuilder: (context, index) =>
                                  const Divider(color: Colors.green),
                              itemBuilder: (context, index) {
                                final friend = filteredFriends[index];
                                return GestureDetector(
                                  onTap: () {
                                    _showRemoveFriendDialog(context, friend);
                                  },
                                  child: ListTile(
                                    title: Text(friend.name,
                                        style: const TextStyle(
                                            color: Colors.green)),
                                    subtitle: Text(friend.username,
                                        style: const TextStyle(
                                            color: Colors.white)),
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
