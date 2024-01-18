class Album {
  final String id;
  final String userId;
  final String name;
  final String albumImg;
  final int? ratingValue;

  Album({
    required this.id,
    required this.userId,
    required this.name,
    required this.albumImg,
    required this.ratingValue,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['_id'],
      userId: json['userId'],
      name: json['name'],
      albumImg: json['albumImg'],
      ratingValue: json['ratingValue'],
    );
  }
}