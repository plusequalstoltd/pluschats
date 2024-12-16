import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/features/profile/domain/entities/profile_user.dart';
import 'package:pluschats/features/profile/presentation/pages/profile_page.dart';

class CustomUserTile extends StatelessWidget {
  final ProfileUser profileUser;
  const CustomUserTile({
    super.key,
    required this.profileUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: profileUser.profileImageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(
            Icons.person_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        profileUser.name,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        profileUser.email,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            uid: profileUser.uid,
          ),
        ),
      ),
    );
  }
}
