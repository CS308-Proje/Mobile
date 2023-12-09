class RecommendationModel {
  final String songName;
  final String mainArtistName;
  final String albumName;
  final String albumImg;

  RecommendationModel(
      {required this.songName,
      required this.mainArtistName,
      required this.albumImg,
      required this.albumName});

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      songName: json['songName'],
      mainArtistName: json['mainArtistName'],
      albumImg: json['albumImg'],
      albumName: json['albumName'],
    );
  }
}
