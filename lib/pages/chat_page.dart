import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/components/custom_chat_bubble.dart';
import 'package:pluschats/components/custom_textfields.dart';
import 'package:pluschats/services/auth/auth_service.dart';
import 'package:pluschats/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;
  ChatPage({super.key, required this.receiverId, required this.receiverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 250),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 250),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessagesStream(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return ListView(
            reverse: true,
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc, context))
                .toList(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred'),
          );
        } else {
          return const Center(
            child: Text('No messages found'),
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: CustomChatBubble(
        message: data['message'],
        currentUser: isCurrentUser,
        messageId: doc.id,
        userId: data['senderId'],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfields(
              hintText: 'Message',
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
