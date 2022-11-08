import 'package:bud/general/config.dart';
import 'package:bud/home_page/ui/home_page.dart';
import 'package:bud/profile_pages/ui/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../location_pages/ui/select_location_page.dart';
import '../controllers/landing_page_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// GetX Controllers
    final LandingPageController landingPageController =
        Get.put<LandingPageController>(LandingPageController());

    /// Bottom navigation bar widget
    Widget buildBottomNavigationBar() {
      return Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: landingPageController.changeTabIndex,
          currentIndex: landingPageController.tabIndex.value,
          selectedItemColor: kNavyBlueColour,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.mapLocationDot),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.faceSmileWink),
              label: 'Me',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kNavyBlueColour,
        onPressed: () => Get.to(() => const SelectLocationPage()),
        child: const Icon(FontAwesomeIcons.plus),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Obx(
        () => getViewForIndex(landingPageController.tabIndex.value),
      ),
    );
  }
}

Widget getViewForIndex(int index) {
  switch (index) {
    case 0:
      return const HomePage();
    case 1:
      return const ProfilePage();
    default:
      return const HomePage();
  }
}
