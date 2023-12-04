class Song {
  final String id;
  final String songName;
  final String mainArtistName;
  final String albumName;
  final String albumImg;

  Song({
    required this.id,
    required this.songName,
    required this.mainArtistName,
    required this.albumName,
    required this.albumImg,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['_id'],
      songName: json['songName'],
      mainArtistName: json['mainArtistName'],
      albumName: json['albumName'],
      albumImg: json['albumImg'],
    );
  }
}