import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config.dart';

class SplashPage extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;

  const SplashPage({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            icon,
            SizedBox(height: mediaQuery.size.height * 0.020),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: mediaQuery.size.height * 0.030,
                fontWeight: FontWeight.w700,
                color: kNavyBlueColour,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.005),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: mediaQuery.size.height * 0.015,
                color: kGreyColour,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
