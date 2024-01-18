class Spotify {
  final String id;
  final String songName;
  final String mainArtistName;
  final String albumName;
  final String albumImg;

  final List<String> featuring;
  final int popularity;
  final int duration;
  final String relaseDate;
  final String artistId;

  Spotify({
    required this.id,
    required this.songName,
    required this.mainArtistName,
    required this.albumName,
    required this.albumImg,
    required this.artistId,
    required this.duration,
    required this.featuring,
    required this.popularity,
    required this.relaseDate,
  });

  factory Spotify.fromJson(Map<String, dynamic> json) {
    return Spotify(
      id: json['_id'] ?? '', // Providing a default value if null
      songName: json['songName'] ?? '', // Providing a default value if null
      mainArtistName:
          json['mainArtistName'] ?? '', // Providing a default value if null
      albumName: json['albumName'] ?? '', // Providing a default value if null
      albumImg: json['albumImg'] ?? '', // Providing a default value if null

      featuring: List<String>.from(json['featuringArtistNames'] ?? []),
      popularity: json['popularity'] ?? 0,
      relaseDate: json['release_date'] ?? '',
      duration: json['duration_ms'] ?? 0,
      artistId: json['artistId'] ?? '',
    );
  }
}
