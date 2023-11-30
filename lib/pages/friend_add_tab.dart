import 'package:flutter/material.dart';

class AddFriendTab extends StatelessWidget {
  final TextEditingController addFriendController;
  final VoidCallback onAddFriendPressed;

  const AddFriendTab({super.key, 
    required this.addFriendController,
    required this.onAddFriendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: addFriendController,
            style: const TextStyle(color: Colors.green),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              hintText: 'Enter friend\'s username...',
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
        const SizedBox(height: 15.0,),
        ElevatedButton(
          onPressed: onAddFriendPressed,
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
                Text('Add Friend', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
