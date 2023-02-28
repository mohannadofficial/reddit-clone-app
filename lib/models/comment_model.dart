import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;

  const CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
  });

  CommentModel copyWith({
    final String? id,
    final String? text,
    final DateTime? createdAt,
    final String? postId,
    final String? username,
    final String? profilePic,
  }) {
    return CommentModel(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      profilePic: profilePic ?? this.profilePic,
      username: username ?? this.username,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
    };
  }

  @override
  List<Object?> get props => [
        id,
        text,
        createdAt,
        postId,
        username,
        profilePic,
      ];
}
