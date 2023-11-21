import 'package:flutter/material.dart';
import 'add_music_info.dart';
import 'add_music_file.dart';
import 'add_music_database.dart';

class AddMusicOptionsPage extends StatelessWidget {
  const AddMusicOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 60.0,
        leading: 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 35),
            onPressed: () => Navigator.of(context).pop(),
          ),
        centerTitle: true,
        title: Image.asset(
          'assets/logo_white.png',
          height: 55,
          width: 55,
        ),
      ),
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOptionButton(
                context, 
                'Add Song via Information',
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMusicInfo()))
              ),
              const SizedBox(height: 30),
              _buildOptionButton(
                context, 
                'Add Songs via File', 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMusicFile()))
              ),
              const SizedBox(height: 30),
              _buildOptionButton(
                context, 
                'Add Songs via Database', 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMusicDatabase()))
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: const BorderSide(color: Colors.green, width: 3.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
