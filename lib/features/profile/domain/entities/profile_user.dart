import 'package:pluschats/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final List<String> followers;
  final List<String> following;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.followers,
    required this.following,
    required this.profileImageUrl,
  });

  ProfileUser copyWith({
    String? newBio,
    List<String>? newFollowers,
    List<String>? newFollowing,
    String? newProfileImageUrl,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'followers': followers,
      'following': following,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'] ?? '',
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
