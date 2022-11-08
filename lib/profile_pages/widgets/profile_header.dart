import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/controllers/auth_controller.dart';
import '../../general/config.dart';
import '../../general/widgets/rounded_button.dart';
import '../controllers/profile_controller.dart';
import '../ui/edit_profile_page.dart';

class ProfileHeader extends StatelessWidget {
  final String profileId;

  const ProfileHeader({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controller
    final AuthController authController = AuthController.to;
    final ProfileController profileController =
        Get.put<ProfileController>(ProfileController(profileId: profileId));

    final double circleAvatarSize = mediaQuery.size.width * 0.12;
    final double profileIconSize = mediaQuery.size.width * 0.10;

    /// Build the Follower and Following count UI
    Column buildCountColumn({
      required String label,
      required int count,
    }) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: mediaQuery.size.width * 0.050,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: mediaQuery.size.width * 0.01),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: mediaQuery.size.width * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }

    /// Build user profile image
    Widget buildCircleAvatar() {
      return CircleAvatar(
        radius: circleAvatarSize,
        backgroundColor: kNavyBlueColour,
        backgroundImage: authController.firestoreUser.value!.photoUrl == ''
            ? null
            : CachedNetworkImageProvider(
                authController.firestoreUser.value!.photoUrl),
        child: authController.firestoreUser.value!.photoUrl == ''
            ? Icon(
                FontAwesomeIcons.solidUser,
                size: profileIconSize,
                color: Colors.white,
              )
            : Container(),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.size.width * 0.05),
      child: Container(
        padding: EdgeInsets.all(mediaQuery.size.height * 0.03),
        margin: EdgeInsets.only(
          top: circleAvatarSize,
          left: mediaQuery.size.width * 0.05,
          right: mediaQuery.size.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Obx(() => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCountColumn(
                      label: "Followers",
                      count: profileController.followerCount.value!,
                    ),
                    SizedBox(width: mediaQuery.size.width * 0.08),
                    buildCircleAvatar(),
                    SizedBox(width: mediaQuery.size.width * 0.08),
                    buildCountColumn(
                      label: "Following",
                      count: profileController.followingCount.value!,
                    ),
                  ],
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Center(
                  child: RoundedButton(
                    buttonText: "Edit profile",
                    buttonColour: kNavyBlueColour,
                    buttonFontSize: mediaQuery.size.width * 0.035,
                    onPressed: () => Get.to(
                        () => const EditProfilePage(isAccountCreation: false)),
                    buttonHeight: mediaQuery.size.width * 0.10,
                    buttonLength: mediaQuery.size.width * 0.40,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.05),
                  child: Text(
                    authController.firestoreUser.value!.username,
                    style: GoogleFonts.poppins(
                      fontSize: mediaQuery.size.width * 0.03,
                      fontWeight: FontWeight.w700,
                      color: kNavyBlueColour,
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.05),
                  child: Text(
                    authController.firestoreUser.value!.bio,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
