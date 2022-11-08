import 'package:bud/authentication/widgets/pin_input_widget.dart';
import 'package:bud/general/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX Controllers
    final AuthController authController = AuthController.to;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height * 0.085),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Verification',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: kNavyBlueColour,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter the code sent to the number',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: kGreyColour,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '+65 ${authController.phoneNumberTextEditingController.text}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: kNavyBlueColour,
                ),
              ),
              Container(
                color: themeData.scaffoldBackgroundColor,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                child: FilledRoundedPinPut(),
              ),
              const SizedBox(height: 44),
              Text(
                "Didn’t receive code?",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(62, 116, 165, 1),
                ),
              ),
              GestureDetector(
                onTap: () => authController.verifyPhoneNumber(),
                child: Text(
                  'Resend',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: const Color.fromRGBO(62, 116, 165, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
