import 'package:bud/home_page/widgets/follow_request_section.dart';
import 'package:bud/social_pages/controllers/social_feed_controller.dart';
import 'package:bud/social_pages/widgets/friend_users_bottom_sheet.dart';
import 'package:bud/social_pages/widgets/search_feed.dart';
import 'package:bud/social_pages/widgets/social_feed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/categories.dart';
import '../../general/config.dart';
import '../../general/widgets/expansion_list.dart';
import '../../general/widgets/rounded_button.dart';
import '../../location_pages/ui/search_location_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final SocialFeedController socialFeedController =
        Get.put<SocialFeedController>(SocialFeedController());

    /// Build FEED search bar
    Widget buildFeedSearchBar() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.50,
            child: ExpansionList(
              items: const [
                Categories.food,
                Categories.beauty,
                Categories.lifestyle,
                Categories.sports,
                Categories.outdoors,
              ],
              title: "Any",
              onItemSelected: (selectedCategory) => socialFeedController
                  .feedSearchCategory.value = selectedCategory,
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.05),
          RoundedButton(
            buttonText: "Search",
            iconWithSizedBox: Row(
              children: [
                Icon(
                  FontAwesomeIcons.locationDot,
                  color: Colors.white,
                  size: mediaQuery.size.width * 0.040,
                ),
                SizedBox(width: mediaQuery.size.width * 0.015),
              ],
            ),
            buttonColour: kPrimaryAccentColour,
            buttonFontSize: mediaQuery.size.width * 0.035,
            onPressed: () =>
                Get.to(() => const SearchLocationPage(isSearchFeed: true)),
            buttonHeight: mediaQuery.size.width * 0.09,
            buttonLength: mediaQuery.size.width * 0.30,
          ),
        ],
      );
    }

    /// Build RESET search button
    Widget buildResetSearchButton() {
      return Center(
        child: RoundedButton(
          buttonText: "Reset",
          iconWithSizedBox: Row(
            children: [
              Icon(
                FontAwesomeIcons.x,
                color: Colors.red,
                size: mediaQuery.size.width * 0.040,
              ),
              SizedBox(width: mediaQuery.size.width * 0.015),
            ],
          ),
          buttonColour: kPrimaryAccentColour,
          buttonFontSize: mediaQuery.size.width * 0.035,
          onPressed: () => socialFeedController.resetFeed(),
          buttonHeight: mediaQuery.size.width * 0.09,
          buttonLength: mediaQuery.size.width * 0.30,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.scaffoldBackgroundColor,
        elevation: 0.0,
        leading: const Icon(
          FontAwesomeIcons.locationDot,
          color: Colors.red,
        ),
        title: Text(
          "Bud",
          style: GoogleFonts.poppins(
            fontSize: mediaQuery.size.width * 0.06,
            fontWeight: FontWeight.w700,
            color: kNavyBlueColour,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) => const FindUsersBottomSheet(),
            ),
            child: CircleAvatar(
              backgroundColor: kNavyBlueColour,
              radius: mediaQuery.size.width * 0.050,
              child: Icon(
                FontAwesomeIcons.userPlus,
                size: mediaQuery.size.width * 0.035,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.04),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: mediaQuery.size.height * 0.02),
          Obx(() => socialFeedController.isSearch.value!
              ? buildResetSearchButton()
              : buildFeedSearchBar()),
          const FollowRequestSection(),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Obx(() => Expanded(
                child: socialFeedController.isSearch.value!
                    ? const SearchFeed()
                    : const SocialFeed(),
              )),
        ],
      ),
    );
  }
}
