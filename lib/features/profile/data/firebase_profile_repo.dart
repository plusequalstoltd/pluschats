import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluschats/features/profile/domain/entities/profile_user.dart';
import 'package:pluschats/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          return ProfileUser(
            uid: userData['uid'],
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            followers: followers,
            following: following,
            profileImageUrl: userData['profileImageUrl']?.toString() ?? '',
          );
        }
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFirestore.collection('users').doc(updateProfile.uid).update(
        {
          'bio': updateProfile.bio,
          'profileImageUrl': updateProfile.profileImageUrl,
        },
      );
    } catch (error) {
      throw Exception('Error updating profile: $error');
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = List<String>.from(
            currentUserData['following'] ?? [],
          );

          // Check if current user is following target user
          if (currentFollowing.contains(targetUid)) {
            // Unfollow
            await firebaseFirestore.collection('users').doc(currentUid).update(
              {
                'following': FieldValue.arrayRemove([targetUid]),
              },
            );
            await firebaseFirestore.collection('users').doc(targetUid).update(
              {
                'followers': FieldValue.arrayRemove([currentUid]),
              },
            );
          } // Follow
          else {
            await firebaseFirestore.collection('users').doc(currentUid).update(
              {
                'following': FieldValue.arrayUnion([targetUid]),
              },
            );
            await firebaseFirestore.collection('users').doc(targetUid).update(
              {
                'followers': FieldValue.arrayUnion([currentUid]),
              },
            );
          }
        }
      }
    } catch (error) {
      throw Exception('Error toggling follow: $error');
    }
  }
}
