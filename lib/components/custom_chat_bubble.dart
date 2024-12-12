import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/services/chat/chat_service.dart';
// import 'package:pluschats/themes/theme_provider.dart';
// import 'package:provider/provider.dart';

class CustomChatBubble extends StatelessWidget {
  final String message;
  final bool currentUser;
  final String messageId;
  final String userId;
  const CustomChatBubble({
    super.key,
    required this.message,
    required this.currentUser,
    required this.messageId,
    required this.userId,
  });

  void showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: Text(
                  'Block User',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ));
        });
  }

  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Report Message',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(
                'Are you sure you want to report this message?',
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
                    ChatService().reportUser(messageId, userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Message reported',
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
                    'Report',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ));
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Block User',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(
                'Are you sure you want to block this user?',
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
                    ChatService().blockUser(userId);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'User blocked',
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
                    'Block',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode =
    //     Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!currentUser) {
          showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: currentUser ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
