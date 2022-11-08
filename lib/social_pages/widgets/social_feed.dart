import 'package:bud/social_pages/controllers/social_feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../general/config.dart';
import '../../general/ui/loading_page.dart';
import '../../general/ui/splash_page.dart';
import '../../models/post_model.dart';
import '../../profile_pages/widgets/profile_post_tile.dart';

class SocialFeed extends StatelessWidget {
  const SocialFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final SocialFeedController socialFeedController = SocialFeedController.to;

    return Obx(
      () {
        List<PostModel>? feedInfo = socialFeedController.userFeedPosts.value;

        return feedInfo != null
            ? feedInfo.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      left: mediaQuery.size.width * 0.06,
                      right: mediaQuery.size.width * 0.06,
                      top: mediaQuery.size.width * 0.03,
                      bottom: mediaQuery.size.width * 0.10,
                    ),
                    shrinkWrap: true,
                    itemCount: feedInfo.length,
                    itemBuilder: (_, index) => Padding(
                      padding:
                          EdgeInsets.only(bottom: mediaQuery.size.width * 0.05),
                      child: ProfilePostTile(
                        post: feedInfo[index],
                        isPost: true,
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        EdgeInsets.only(top: mediaQuery.size.height * 0.10),
                    child: SplashPage(
                      icon: Icon(
                        FontAwesomeIcons.mapLocationDot,
                        color: kNavyBlueColour,
                        size: mediaQuery.size.width * 0.15,
                      ),
                      title: "Empty Feed",
                      subtitle: "Follow more people to build your Feed!",
                    ),
                  )
            : const LoadingPage();
      },
    );
  }
}
