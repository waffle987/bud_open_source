import 'package:bud/general/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/widgets/progress_indicators.dart';
import '../controllers/auth_controller.dart';

class UnauthPage extends StatelessWidget {
  const UnauthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX Controllers
    final AuthController authController = AuthController.to;

    /// Build the phone number section
    Widget buildPhoneNumberSection() {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.size.height * 0.02,
          horizontal: mediaQuery.size.width * 0.06,
        ),
        child: Row(
          children: <Widget>[
            Text(
              "🇸🇬  +65",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(30, 60, 87, 1),
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.05),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(38.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextField(
                      controller:
                          authController.phoneNumberTextEditingController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: const Color.fromRGBO(133, 153, 170, 1),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color.fromRGBO(133, 153, 170, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => authController.isLoading.value
                ? circularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      color: kNavyBlueColour,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(38.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () => authController.verifyPhoneNumber(),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      );
    }

    /// Build title section
    Widget buildTitleSection() {
      return Column(
        children: [
          Icon(
            FontAwesomeIcons.locationDot,
            size: mediaQuery.size.width * 0.15,
            color: Colors.red,
          ),
          SizedBox(height: mediaQuery.size.width * 0.03),
          Text(
            "Bud",
            style: GoogleFonts.poppins(
              fontSize: mediaQuery.size.width * 0.11,
              fontWeight: FontWeight.w700,
              color: kNavyBlueColour,
            ),
          ),
          Text(
            "Your social directory",
            style: GoogleFonts.poppins(
              fontSize: mediaQuery.size.width * 0.05,
              fontWeight: FontWeight.w700,
              color: kGreyColour,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTitleSection(),
          buildPhoneNumberSection(),
        ],
      )),
    );
  }
}
