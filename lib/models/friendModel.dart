class Friend {
  final String id;
  final String name;
  final String username;
  final String email;
  List<String> allowFriendRecommendations;

  Friend({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    List<String>? allowFriendRecommendations,
  }) : allowFriendRecommendations = allowFriendRecommendations ?? [];

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      allowFriendRecommendations: List<String>.from(json['allowFriendRecommendations']),
    );
  }
}