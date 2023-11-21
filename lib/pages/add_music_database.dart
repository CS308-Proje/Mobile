import 'package:flutter/material.dart';

class AddMusicDatabase extends StatefulWidget {
  const AddMusicDatabase({super.key});

  @override
  _AddMusicDatabaseState createState() => _AddMusicDatabaseState();
}

class _AddMusicDatabaseState extends State<AddMusicDatabase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String databaseURI = '';
  String collectionName = '';
  String databaseName = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      
      print('Database URI: $databaseURI');
      print('Collection Name: $collectionName');
      print('Database Name: $databaseName');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Song(s) added successfully!'),
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
                  labelText: 'Database URI', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter database URI' : null,
                onSaved: (value) => databaseURI = value!,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Collection Name', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter collection Name' : null,
                onSaved: (value) => collectionName = value!,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Database Name', 
                  labelStyle: TextStyle(fontSize: 20, color: Colors.green)
                ), 
                style: const TextStyle(fontSize: 20, color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter database name' : null,
                onSaved: (value) => databaseName = value!,
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
                child: const Text('Add Song(s)',)
              ),
            ],
          ),
        ),
      ),
    );
  }
}