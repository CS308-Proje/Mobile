class Album {
  final String id;
  final String userId;
  final String name;
  final String artistId;

  Album({
    required this.id,
    required this.userId,
    required this.name,
    required this.artistId,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['_id'],
      userId: json['userId'],
      name: json['name'],
      artistId: json['artistId']
    );
  }
}