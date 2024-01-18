class Artist {
  final String id;
  final String userId;
  final String artistName;
  final String artistImg;
  final int? ratingValue;
  Artist({
    required this.id,
    required this.userId,
    required this.artistName,
    required this.artistImg,
    required this.ratingValue,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['_id'],
      userId: json['userId'],
      artistName: json['artistName'],
      artistImg: json['artistImg'],
      ratingValue: json['ratingValue'],
    );
  }
}