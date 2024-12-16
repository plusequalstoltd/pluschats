import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/features/auth/domain/entities/app_user.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_cubit.dart';
// import 'package:pluschats/features/posts/presentaion/components/custom_post_tile.dart';
// import 'package:pluschats/features/posts/presentaion/cubits/post_cubit.dart';
// import 'package:pluschats/features/posts/presentaion/cubits/post_states.dart';
import 'package:pluschats/features/profile/presentation/components/custom_bio_box.dart';
import 'package:pluschats/features/profile/presentation/components/custom_follow_button.dart';
import 'package:pluschats/features/profile/presentation/components/custom_profile_stats.dart';
import 'package:pluschats/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:pluschats/features/profile/presentation/cubits/profile_state.dart';
import 'package:pluschats/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:pluschats/features/profile/presentation/pages/follower_page.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.currentUser;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = widget.uid == currentUser!.uid;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          return ConstrainedScaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (isOwnProfile)
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: Center(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 20),
                  CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      user.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomProfileStats(
                    postCount: postCount,
                    followerCount: user.followers.length,
                    followingCount: user.following.length,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerPage(
                          followers: user.followers,
                          following: user.following,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isOwnProfile)
                    CustomFollowButton(
                      onPressed: () => followButtonPressed(),
                      isFollowing: user.followers.contains(currentUser!.uid),
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomBioBox(text: user.bio),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  //   if (state is PostsLoaded) {
                  //     final userPosts = state.posts
                  //         .where((post) => post.userId == widget.uid)
                  //         .toList();
                  //     postCount = userPosts.length;
                  //     return ListView.builder(
                  //       itemCount: postCount,
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       itemBuilder: (context, index) {
                  //         final post = userPosts[index];
                  //         return CustomPostTile(
                  //           post: post,
                  //           onDeletePressed: () =>
                  //               context.read<PostCubit>().deletePost(post.id),
                  //         );
                  //       },
                  //     );
                  //   } else if (state is PostsLoading) {
                  //     return const Center(
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   } else {
                  //     return Text(
                  //       'No Posts',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Theme.of(context).colorScheme.onPrimaryFixed,
                  //         fontFamily: GoogleFonts.poppins().fontFamily,
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     );
                  //   }
                  // }),
                ],
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return const ConstrainedScaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No profile found',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimaryFixed,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}
