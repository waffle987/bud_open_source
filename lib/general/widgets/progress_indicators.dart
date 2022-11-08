import 'package:bud/general/config.dart';
import 'package:flutter/material.dart';

Container circularProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 10.0),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimaryAccentColour),
    ),
  );
}

linearProgressIndicator() {
  return Container(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimaryAccentColour),
    ),
  );
}
