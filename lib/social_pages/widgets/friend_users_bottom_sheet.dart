import 'package:bud/general/widgets/rounded_button.dart';
import 'package:bud/general/widgets/text_input_field.dart';
import 'package:bud/social_pages/controllers/social_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';

class FindUsersBottomSheet extends StatelessWidget {
  const FindUsersBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final SocialController socialController = SocialController.to;

    /// Build text info
    Widget buildInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Username",
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: kNavyBlueColour,
            ),
          ),
          Text(
            'Enter the exact username of another user to send a follow request',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: kGreyColour,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: mediaQuery.size.width * 0.10,
        right: mediaQuery.size.width * 0.10,
        top: mediaQuery.size.width * 0.07,
        bottom: mediaQuery.viewInsets.bottom,
      ),
      child: Container(
          height: mediaQuery.size.height * 0.40,
          width: mediaQuery.size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildInfo(),
                SizedBox(height: mediaQuery.size.width * 0.03),
                TextInputField(
                  controller: socialController.usernameTextController,
                  fillColour: kLightGreyColour,
                ),
                SizedBox(height: mediaQuery.size.width * 0.05),
                RoundedButton(
                  buttonText: "Send",
                  buttonColour: kPrimaryAccentColour,
                  buttonFontSize: mediaQuery.size.width * 0.04,
                  onPressed: () => socialController.sendFollowRequest(),
                  buttonHeight: mediaQuery.size.width * 0.09,
                  buttonLength: mediaQuery.size.width * 0.30,
                ),
              ],
            ),
          )),
    );
  }
}
