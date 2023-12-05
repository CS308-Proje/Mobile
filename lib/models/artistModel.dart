class Artist {
  final String id;
  final String userId;
  final String artistName;

  Artist({
    required this.id,
    required this.userId,
    required this.artistName,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['_id'],
      userId: json['userId'],
      artistName: json['artistName']
    );
  }
}