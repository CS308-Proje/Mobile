import 'package:flutter/material.dart';

class AddMusicInfo extends StatefulWidget {
  const AddMusicInfo({super.key});

  @override
  _AddMusicInfoState createState() => _AddMusicInfoState();
}

class _AddMusicInfoState extends State<AddMusicInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String songName = '';
  String albumName = '';
  String mainArtist = '';
  String featuringArtists = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> featuringArtistList = featuringArtists.isNotEmpty
        ? featuringArtists.split(',').map((s) => s.trim()).toList()
        : [];
      
      print('Song Name: $songName');
      print('Album Name: $albumName');
      print('Main Artist: $mainArtist');
      print('Featuring Artists: $featuringArtistList');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Song added successfully!'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.green, width: 2.5),
            ),
            titleTextStyle: const TextStyle(fontSize: 25, color: Colors.green),
            contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
            backgroundColor: Colors.grey[800],
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green, // Color for text
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          );
        },
      );
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Song Name', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter song name' : null,
                onSaved: (value) => songName = value!,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Album Name', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter album name' : null,
                onSaved: (value) => albumName = value!,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Main Artist Name', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter main artist name' : null,
                onSaved: (value) => mainArtist = value!,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Featuring Artist Names', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                  ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter featuring artist names' : null,
                onSaved: (value) => featuringArtists = value ?? '',
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: Colors.white, width: 3.0),
                  ),
                ),
                child: const Text('Add Song',)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
