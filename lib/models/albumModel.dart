class Album {
  final String id;
  final String userId;
  final String name;

  Album({
    required this.id,
    required this.userId,
    required this.name,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['_id'],
      userId: json['userId'],
      name: json['name'],
    );
  }
}