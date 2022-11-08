import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final Widget? iconWithSizedBox;
  final String buttonText;
  final Color? buttonTextColor;
  final Color buttonColour;
  final Function() onPressed;
  final double buttonFontSize;
  final double buttonHeight;
  final double buttonLength;

  const RoundedButton({
    Key? key,
    this.iconWithSizedBox,
    this.buttonTextColor = Colors.white,
    required this.buttonText,
    required this.buttonColour,
    required this.buttonFontSize,
    required this.onPressed,
    required this.buttonHeight,
    required this.buttonLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: buttonHeight,
        width: buttonLength,
        decoration: BoxDecoration(
          color: buttonColour,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWithSizedBox != null ? iconWithSizedBox! : Container(),
              Text(
                buttonText,
                style: GoogleFonts.poppins(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w700,
                  color: buttonTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
