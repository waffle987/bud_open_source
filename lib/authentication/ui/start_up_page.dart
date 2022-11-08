import 'package:bud/authentication/ui/landing_page.dart';
import 'package:bud/profile_pages/ui/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../general/ui/loading_page.dart';
import '../controllers/auth_controller.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// GetX controllers
    final AuthController authController = AuthController.to;

    return Obx(() => authController.firestoreUser.value == null
        ? const LoadingPage()
        : authController.firestoreUser.value!.username == ""
            ? const EditProfilePage(isAccountCreation: true)
            : const LandingPage());
  }
}
