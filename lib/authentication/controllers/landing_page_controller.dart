import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../general/config.dart';

class LandingPageController extends GetxController {
  RxInt tabIndex = 0.obs;
  RxBool reverse = false.obs;

  /// Instantiate 3rd party packages
  final Location location = Location();

  /// GetX controllers
  final AuthController authController = AuthController.to;

  @override
  void onInit() async {
    /// Check current permission status
    PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      /// Request location permission from USER
      await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar(
          'No Permission'.tr,
          "Please enable location permissions to post",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: kPrimaryAccentColour,
          colorText: Colors.white,
        );
      }
    }

    super.onInit();
  }

  /// Change the tab index when the bottom navigation bar is pressed
  void changeTabIndex(int index) {
    if (index < tabIndex.value) {
      reverse.value = true;
    } else {
      reverse.value = false;
    }

    tabIndex.value = index;
  }
}
