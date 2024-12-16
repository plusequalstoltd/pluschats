import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/features/profile/presentation/components/custom_user_tile.dart';
import 'package:pluschats/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: AppBar(
          // title: Text(
          //   'Followers',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Theme.of(context).colorScheme.onPrimaryFixed,
          //     fontFamily: GoogleFonts.poppins().fontFamily,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            labelStyle: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(
                text: 'Followers',
              ),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(
              followers,
              'No followers yet',
              context,
            ),
            _buildUserList(
              following,
              'Not following anyone yet',
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryFixed,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return CustomUserTile(profileUser: user);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text(
                        'User not found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
  }
}
