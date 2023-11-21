import 'package:flutter/material.dart';

class MusicRemovePage extends StatefulWidget {
  const MusicRemovePage({super.key});

  @override
  _MusicRemovePageState createState() => _MusicRemovePageState();
}

class _MusicRemovePageState extends State<MusicRemovePage> {
  String _selectedOption = 'Song'; // Default selection
  TextEditingController searchController = TextEditingController();
  List<String> _allItems = []; // List to hold all items
  List<String> _items = []; // List to hold songs, albums, or artists
  List<String> songs = [
    "Shape of You",
    "Blinding Lights",
    "Uptown Funk",
    "Old Town Road",
    "Sunflower",
    "Thinking Out Loud",
    "Despacito",
    "God's Plan",
    "Perfect",
    "All of Me",
    "Closer",
    "Rockstar",
    "Someone You Loved",
    "Bad Guy",
    "Believer"
  ];
  List<String> albums = [
    "Thriller",
    "Back in Black",
    "The Dark Side of the Moon",
    "The Bodyguard",
    "Rumours",
    "Saturday Night Fever",
    "Abbey Road",
    "Born in the U.S.A.",
    "Hotel California",
    "1",
    "21",
    "Nevermind",
    "Diamonds",
    "Falling into You",
    "1989"
  ];
  List<String> artists = [
    "The Beatles",
    "Michael Jackson",
    "Elvis Presley",
    "Madonna",
    "Elton John",
    "Led Zeppelin",
    "Pink Floyd",
    "Rihanna",
    "Mariah Carey",
    "The Rolling Stones",
    "Taylor Swift",
    "Bob Dylan",
    "Queen",
    "U2",
    "Bruce Springsteen"
  ];

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load initial data
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchSongs();
  // }

  // void fetchSongs() async {
  //   var url = Uri.parse('http://10.0.2.2:5001/songs');
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body) as List;
  //     setState(() {
  //       _allItems = jsonResponse.map((song) => song['name'].toString()).toList();
  //       _items = List.from(_allItems);
  //     });
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  void _loadItems() {
    if (_selectedOption == 'Song') {
      _allItems = songs;
    } else if (_selectedOption == 'Album') {
      _allItems = albums;
    } else if (_selectedOption == 'Artist') {
      _allItems = artists;
    }

    _items = List.from(
        _allItems); // Initially, all items of the selected type are displayed
    setState(() {}); // Update UI
  }

  void _filterItems(String searchText) {
    if (searchText.isEmpty) {
      _items =
          List.from(_allItems); // Display all items if search text is empty
    } else {
      _items = _allItems
          .where(
              (item) => item.toLowerCase().contains(searchText.toLowerCase()))
          .toList(); // Filter items based on search text
    }
    setState(() {}); // Update UI
  }

  void _clearSearch() {
    searchController.clear();
    _filterItems('');
  }

  void _removeItem(String item) {
    setState(() {
      _allItems.remove(item);
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            ////////////////
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  <String>['Song', 'Album', 'Artist'].map((String option) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = option;
                      _loadItems();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == option
                        ? Colors.green
                        : Colors.grey[800],
                    side: BorderSide(
                      color: _selectedOption == option
                          ? Colors.white
                          : Colors
                              .green, // Border color changes based on selection
                      width: 2.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Search...', // Using hintText instead of labelText
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Colors.green, width: 3.0), // Blue frame
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Colors.green, width: 3.0), // Blue frame
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Colors.white, width: 3.0), // Blue frame
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
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18) // Increased font size
                        ),
                    onTap: () => _showConfirmationDialog(_items[index]),
                  );
                },
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal',
              style: TextStyle(color: Colors.green)),
          content: Text('Are you sure you want to remove "$item"?',
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
                _removeItem(item); // Remove the item
                Navigator.of(context).pop();
                _clearSearch();
              },
            ),
          ],
        );
      },
    );
  }
}
