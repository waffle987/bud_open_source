import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/config.dart';
import 'package:bud/profile_pages/widgets/profile_header.dart';
import 'package:bud/profile_pages/widgets/profile_post_feed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../social_pages/controllers/social_feed_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final AuthController authController = AuthController.to;
    final SocialFeedController socialFeedController = SocialFeedController.to;

    /// Build bubble tab bar
    Widget buildTabBar() {
      /// Text style for the bubble tab
      TextStyle bubbleTabTextStyle() {
        return TextStyle(fontSize: mediaQuery.size.width * 0.035);
      }

      return TabBar(
        indicator: BubbleTabIndicator(
          indicatorColor: kNavyBlueColour,
          indicatorHeight: mediaQuery.size.width * 0.08,
          indicatorRadius: mediaQuery.size.width * 0.40,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: mediaQuery.size.width * 0.035,
        ),
        tabs: <Widget>[
          Tab(
            child: Text(
              'Posts',
              style: bubbleTabTextStyle(),
            ),
          ),
          Tab(
            child: Text(
              'Pins',
              style: bubbleTabTextStyle(),
            ),
          ),
        ],
      );
    }

    /// Build sign out button
    Widget buildSignOutButton() {
      return Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top,
          left: mediaQuery.size.width * 0.85,
        ),
        child: GestureDetector(
          onTap: () {
            authController.signOut();
            socialFeedController.dispose();
          },
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: mediaQuery.size.width * 0.05,
            child: Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: Colors.white,
              size: mediaQuery.size.width * 0.05,
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.width * 0.02),
                  ProfileHeader(
                      profileId: authController.firestoreUser.value!.id),
                  Container(
                    width: double.infinity,
                    height: mediaQuery.size.height * 0.06,
                    margin: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.05),
                    alignment: Alignment.center,
                    child: buildTabBar(),
                  ),
                  SizedBox(height: mediaQuery.size.width * 0.05),
                  const Expanded(
                      child: TabBarView(
                    children: [
                      ProfileFeed(isPost: true),
                      ProfileFeed(isPost: false),
                    ],
                  ))
                ],
              ),
            ),
          ),
          buildSignOutButton(),
        ],
      ),
    );
  }
}
