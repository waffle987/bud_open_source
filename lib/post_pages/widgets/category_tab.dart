import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';

class CategoryTab extends StatelessWidget {
  final String category;
  final double textFontSize;
  final Widget? trailingWidget;

  const CategoryTab({
    Key? key,
    required this.category,
    required this.textFontSize,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: kNavyBlueColour,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
      ),
      child: Center(
        child: Row(
          children: [
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: textFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailingWidget != null ? trailingWidget! : Container(),
          ],
        ),
      ),
    );
  }
}
