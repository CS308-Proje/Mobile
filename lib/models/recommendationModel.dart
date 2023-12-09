class RecommendationModel {
  final String songName;
  final String mainArtistName;
  final String albumImg;

  RecommendationModel({
    required this.songName,
    required this.mainArtistName,
    required this.albumImg,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      songName: json['songName'],
      mainArtistName: json['mainArtistName'],
      albumImg: json['albumImg'],
    );
  }
}
