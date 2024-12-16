import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBioBox extends StatelessWidget {
  final String text;
  const CustomBioBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Text(
        text.isNotEmpty ? text : 'Empty bio',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
