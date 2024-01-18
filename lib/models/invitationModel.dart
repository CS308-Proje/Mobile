class Invitation {
  final String id;
  final String userId;
  final String targetUserId;
  final String status;

  Invitation({
    required this.id,
    required this.userId,
    required this.targetUserId,
    required this.status,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      targetUserId: json['targetUserId'] as String,
      status: json['status'] as String,
    );
  }
}