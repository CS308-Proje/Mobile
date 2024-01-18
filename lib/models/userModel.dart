class User {
  String id;
  String name;
  String username;
  String email;
  String password;
  String role;
  List<String> friends;
  List<String> allowFriendRecommendations;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.friends,
    required this.allowFriendRecommendations,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      friends: List<String>.from(json['friends'].map((friend) => friend['_id'])),
      allowFriendRecommendations: List<String>.from(json['allowFriendRecommendations'].map((friend) => friend['_id'])),
    );
  }
}