import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/components/custom_user_tile.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';
import 'package:pluschats/services/auth/auth_service.dart';
import 'package:pluschats/services/chat/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unblock User',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to unblock this user?',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _chatService.unBlockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'User unblocked',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Unblock',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;
    return ConstrainedScaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Blocked Users',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUsersStream(userId),
          builder: (context, snapshot) {
            final blockedUsers = snapshot.data ?? [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred'),
              );
            }
            if (blockedUsers.isEmpty) {
              return const Center(
                child: Text('No blocked users found'),
              );
            }
            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return CustomUserTile(
                  text: user['email'],
                  onTap: () => _showUnblockBox(context, user['uid']),
                );
              },
            );
          },
        ));
  }
}
