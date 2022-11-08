import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/ui/loading_page.dart';
import 'package:bud/general/ui/splash_page.dart';
import 'package:bud/models/post_model.dart';
import 'package:bud/profile_pages/controllers/profile_feed_controller.dart';
import 'package:bud/profile_pages/widgets/profile_post_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../general/config.dart';

class ProfileFeed extends StatelessWidget {
  final bool isPost;

  const ProfileFeed({
    Key? key,
    required this.isPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final AuthController authController = AuthController.to;
    final ProfileFeedController profileFeedController =
        Get.put<ProfileFeedController>(ProfileFeedController(
            profileId: authController.firestoreUser.value!.id));

    return Obx(
      () {
        List<PostModel>? feedInfo = isPost
            ? profileFeedController.userPosts.value
            : profileFeedController.userPins.value;

        /// Text for Splash Screen title
        final String splashTitle = isPost ? "posts" : "pins";

        /// Icon for Splash Screen
        final Icon splashIcon = isPost
            ? Icon(
                FontAwesomeIcons.cameraRetro,
                color: kNavyBlueColour,
                size: mediaQuery.size.height * 0.07,
              )
            : Icon(
                FontAwesomeIcons.locationDot,
                color: Colors.red,
                size: mediaQuery.size.height * 0.07,
              );

        return feedInfo != null
            ? feedInfo.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      left: mediaQuery.size.width * 0.06,
                      right: mediaQuery.size.width * 0.06,
                      bottom: mediaQuery.size.width * 0.10,
                    ),
                    shrinkWrap: true,
                    itemCount: feedInfo.length,
                    itemBuilder: (_, index) => Padding(
                      padding:
                          EdgeInsets.only(bottom: mediaQuery.size.width * 0.05),
                      child: ProfilePostTile(
                        post: feedInfo[index],
                        isPost: isPost,
                      ),
                    ),
                  )
                : Center(
                    child: SplashPage(
                      icon: splashIcon,
                      title: "No $splashTitle yet",
                      subtitle: "Out finding locations",
                    ),
                  )
            : const LoadingPage();
      },
    );
  }
}
