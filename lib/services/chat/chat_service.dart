import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pluschats/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userSnapshot = await _firestore.collection('users').get();

      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  Future<void> sendMessage(
      String receiverId, String receiverEmail, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomID = ids.join('_');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessagesStream(String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();

    String chatRoomID = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': Timestamp.now(),
    };
    await _firestore.collection('reports').add(report);
  }

  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  Future<void> unBlockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .doc(blockedUserId)
        .delete();
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    // final currentUser = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('blocked_users')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('users').doc(id).get()),
      );

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
