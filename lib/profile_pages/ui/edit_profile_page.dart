import 'dart:io';

import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/authentication/ui/start_up_page.dart';
import 'package:bud/general/controllers/image_picker_controller.dart';
import 'package:bud/general/widgets/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';
import '../../general/widgets/text_input_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final bool isAccountCreation;

  const EditProfilePage({
    Key? key,
    required this.isAccountCreation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final AuthController authController = AuthController.to;
    final ImagePickerController imagePickerController =
        Get.put<ImagePickerController>(ImagePickerController());
    final EditProfileController profileController =
        Get.put<EditProfileController>(EditProfileController());

    /// Stored values
    final double circleAvatarSize = mediaQuery.size.width * 0.15;
    final double profileIconSize = mediaQuery.size.width * 0.13;

    /// Build circle avatar
    Widget buildCircleAvatar() {
      return Obx(
        () => imagePickerController.selectedImage.value != null
            ? CircleAvatar(
                radius: circleAvatarSize,
                backgroundImage: Image.file(
                        File(imagePickerController.selectedImage.value!.path))
                    .image,
              )
            : authController.firestoreUser.value!.photoUrl != ""
                ? CircleAvatar(
                    radius: circleAvatarSize,
                    backgroundImage: CachedNetworkImageProvider(
                        authController.firestoreUser.value!.photoUrl),
                  )
                : CircleAvatar(
                    backgroundColor: kNavyBlueColour,
                    radius: circleAvatarSize,
                    child: Icon(
                      FontAwesomeIcons.solidUser,
                      size: profileIconSize,
                      color: Colors.white,
                    ),
                  ),
      );
    }

    /// Build the text field section
    Widget textFieldSection({
      required String title,
      required TextEditingController textEditingController,
      required String placeholder,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: mediaQuery.size.width * 0.05,
                color: kNavyBlueColour,
              ),
            ),
            SizedBox(height: mediaQuery.size.width * 0.02),
            TextInputField(
              controller: textEditingController,
              placeholder: placeholder,
              fillColour: kLightGreyColour,
            )
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kNavyBlueColour,
        onPressed: () async {
          bool error = false;

          if (authController.firestoreUser.value!.username == "" ||
              authController.firestoreUser.value!.bio == "") {
            error = true;
          }

          /// Update profile image if any changes
          if (imagePickerController.selectedImage.value != null) {
            profileController.updateProfilePicture();
          }

          /// Update username if any changes
          if (profileController.usernameTextEditingController.text.isNotEmpty) {
            /// Check if username exists
            bool usernameExist =
                await profileController.checkIfUsernameExists();

            if (!usernameExist) {
              /// Update username
              profileController.updateUsername();
            } else {
              error = true;

              Get.snackbar(
                'Username exists'.tr,
                "Please try another one",
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 10),
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }

          /// Update bio if any changes
          if (profileController.bioTextEditingController.text.isNotEmpty) {
            profileController.updateBio();
          }

          if (!error) {
            if (imagePickerController.selectedImage.value == null &&
                profileController.usernameTextEditingController.text.isEmpty &&
                profileController.bioTextEditingController.text.isEmpty) {
              if (isAccountCreation) {
                /// Redirect to Startup Page
                Get.off(() => const StartUpPage());
              } else {
                Get.back();
              }
            } else {
              Get.snackbar(
                'Updated'.tr,
                "Your profile has been successfully updated",
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 10),
                backgroundColor: kPrimaryAccentColour,
                colorText: Colors.white,
              );

              if (isAccountCreation) {
                /// Redirect to Startup Page
                Get.off(() => const StartUpPage());
              } else {
                Get.back();
              }
            }
          }
        },
        child: const Icon(FontAwesomeIcons.check),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mediaQuery.size.height * 0.01),
                Text(
                  "My Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: kNavyBlueColour,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.05),
                buildCircleAvatar(),
                SizedBox(height: mediaQuery.size.height * 0.05),
                RoundedButton(
                  buttonText: "Upload pic",
                  buttonColour: kPrimaryAccentColour,
                  buttonFontSize: mediaQuery.size.width * 0.04,
                  onPressed: () =>
                      imagePickerController.selectSingleImageFromGallery(),
                  buttonHeight: mediaQuery.size.width * 0.10,
                  buttonLength: mediaQuery.size.width * 0.40,
                ),
                SizedBox(height: mediaQuery.size.height * 0.08),
                textFieldSection(
                  title: "Username",
                  textEditingController:
                      profileController.usernameTextEditingController,
                  placeholder: authController.firestoreUser.value!.username,
                ),
                SizedBox(height: mediaQuery.size.height * 0.04),
                textFieldSection(
                  title: "Bio",
                  textEditingController:
                      profileController.bioTextEditingController,
                  placeholder: authController.firestoreUser.value!.bio,
                ),
                SizedBox(height: mediaQuery.size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
