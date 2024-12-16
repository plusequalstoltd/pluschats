import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/components/custom_drawer.dart';
import 'package:pluschats/components/custom_user_tile.dart';
import 'package:pluschats/features/auth/domain/entities/app_user.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:pluschats/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:pluschats/main.dart';
import 'package:pluschats/features/chat/chat_page.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';
import 'package:pluschats/services/chat/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  Stream<List<Map<String, dynamic>>>? usersStream;

  late final profileCubit = context.read<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    // Logic for refreshing data
    usersStream = _chatService.getUsersStreamExcludingBlocked();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit =
        context.watch<AuthCubit>(); // Watch for current user updates

    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'PlusChats',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: _buildUserList(authCubit.currentUser),
    );
  }

  Widget _buildUserList(AppUser? currentUser) {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              children: snapshot.data!
                  .map<Widget>((userData) =>
                      _buildUserListItem(userData, context, currentUser))
                  .toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred'),
          );
        } else {
          return const Center(
            child: Text('No users found'),
          );
        }
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context,
      AppUser? currentUser) {
    if (currentUser != null && userData['email'] != currentUser.email) {
      logger.d(
          'Receiver uid: ${userData['uid']}\nReceiver email: ${userData['email']}');
      return CustomUserTile(
        userData: userData,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverId: userData['uid'],
                receiverEmail: userData['email'],
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
