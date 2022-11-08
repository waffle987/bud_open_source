import 'package:bud/general/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CircleBackButton extends StatelessWidget {
  const CircleBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top,
        left: mediaQuery.size.width * 0.03,
      ),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: CircleAvatar(
          backgroundColor: kPrimaryAccentColour,
          radius: mediaQuery.size.width * 0.06,
          child: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
            size: mediaQuery.size.width * 0.07,
          ),
        ),
      ),
    );
  }
}
