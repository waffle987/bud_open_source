import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';
import '../../social_pages/controllers/social_controller.dart';
import 'follow_request_tile.dart';

class FollowRequestSection extends StatelessWidget {
  const FollowRequestSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final SocialController socialController =
        Get.put<SocialController>(SocialController());

    return Obx(() {
      return socialController.requestList.value != null &&
              socialController.requestList.value!.isNotEmpty
          ? Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.01),
                Row(
                  children: [
                    SizedBox(width: mediaQuery.size.width * 0.04),
                    Text(
                      'Friend Requests',
                      style: GoogleFonts.poppins(
                        fontSize: mediaQuery.size.width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: kNavyBlueColour,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: socialController.requestList.value!.length,
                  itemBuilder: (_, index) => Column(
                    children: [
                      FollowRequestTile(
                          followRequest:
                              socialController.requestList.value![index]),
                      const Divider(),
                    ],
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
              ],
            )
          : Container();
    });
  }
}
