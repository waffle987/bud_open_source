import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/widgets/circle_back_button.dart';
import 'package:bud/general/widgets/pop_up_dialog.dart';
import 'package:bud/general/widgets/rounded_button.dart';
import 'package:bud/models/post_model.dart';
import 'package:bud/post_pages/controllers/post_controller.dart';
import 'package:bud/post_pages/widgets/recommendation_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../general/config.dart';
import '../../general/widgets/progress_indicators.dart';
import '../widgets/category_tab.dart';
import '../widgets/post_owner_info.dart';

class PostPage extends StatelessWidget {
  final PostModel post;
  final bool isPost;

  const PostPage({
    Key? key,
    required this.post,
    required this.isPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final AuthController authController = AuthController.to;
    final PostController postController =
        Get.put<PostController>(PostController(
      post: post,
      isPost: isPost,
    ));

    /// Build the UI for the round Recommendation indicator
    Widget buildRoundRecommendationIndicator() {
      return Positioned(
        top: mediaQuery.size.height * 0.56,
        right: mediaQuery.size.width * 0.08,
        child: RecommendationIndicator(
          post: post,
          radius: mediaQuery.size.width * 0.075,
        ),
      );
    }

    /// Build Google Map Widget
    Widget buildGoogleMapWidget() {
      /// Get GeoPoint
      GeoPoint geoPoint = post.position["geopoint"];

      /// Google Maps widget values
      final markers = <Marker>{
        Marker(
          markerId: const MarkerId("post location"),
          position: LatLng(
            geoPoint.latitude,
            geoPoint.longitude,
          ),
        ),
      };
      MarkerId markerId = const MarkerId("selected-location");

      return Column(
        children: [
          Text(
            "Location",
            maxLines: 2,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: kNavyBlueColour,
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.02),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.05),
            height: mediaQuery.size.height * 0.30,
            child: GoogleMap(
              onCameraMove: (CameraPosition position) {
                markers
                    .add(Marker(markerId: markerId, position: position.target));
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  geoPoint.latitude,
                  geoPoint.longitude,
                ),
                zoom: 15,
              ),
              markers: markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      );
    }

    /// Build post information
    Widget buildInformationSection() {
      /// Build ICON with STAT
      Widget buildIconStat({
        required Widget icon,
        required String number,
      }) {
        return Row(
          children: [
            Text(
              number,
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: kNavyBlueColour,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.02),
            icon,
          ],
        );
      }

      /// Build "PIN" row
      Widget buildPinRow() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => buildIconStat(
                  number: postController.pinCount.value.toString(),
                  icon: const Icon(
                    FontAwesomeIcons.locationDot,
                    color: Colors.red,
                  ),
                )),
            SizedBox(width: mediaQuery.size.width * 0.05),
            Obx(() => RoundedButton(
                  iconWithSizedBox: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        color: postController.isPinned.value
                            ? Colors.red
                            : Colors.white,
                      ),
                      SizedBox(width: mediaQuery.size.width * 0.01),
                    ],
                  ),
                  buttonText: postController.isPinned.value ? "Unpin" : "Pin",
                  buttonTextColor: postController.isPinned.value
                      ? Colors.black
                      : Colors.white,
                  buttonColour: postController.isPinned.value
                      ? Colors.white
                      : Colors.pinkAccent,
                  buttonFontSize: mediaQuery.size.width * 0.04,
                  onPressed: postController.isPinned.value
                      ? () => postController.unpinPost()
                      : () => postController.pinPost(),
                  buttonHeight: mediaQuery.size.width * 0.10,
                  buttonLength: mediaQuery.size.width * 0.40,
                )),
          ],
        );
      }

      /// Build "VISIT" row
      Widget buildVisitRow() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => buildIconStat(
                  number: postController.visitCount.value.toString(),
                  icon: const Icon(
                    FontAwesomeIcons.personRunning,
                    color: kPrimaryAccentColour,
                  ),
                )),
            SizedBox(width: mediaQuery.size.width * 0.05),
            Obx(() => RoundedButton(
                  iconWithSizedBox: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.personRunning,
                        color: postController.isVisited.value
                            ? kPrimaryAccentColour
                            : Colors.white,
                      ),
                      SizedBox(width: mediaQuery.size.width * 0.01),
                    ],
                  ),
                  buttonText: postController.isVisited.value ? "Undo" : "Done",
                  buttonTextColor: postController.isVisited.value
                      ? Colors.black
                      : Colors.white,
                  buttonColour: postController.isVisited.value
                      ? Colors.white
                      : kPrimaryAccentColour,
                  buttonFontSize: mediaQuery.size.width * 0.04,
                  onPressed: postController.isVisited.value
                      ? () => postController.unvisit()
                      : () => postController.visit(),
                  buttonHeight: mediaQuery.size.width * 0.10,
                  buttonLength: mediaQuery.size.width * 0.40,
                )),
          ],
        );
      }

      /// Build Categories row
      Widget buildCategoryRow() {
        return SizedBox(
          height: mediaQuery.size.height * 0.055,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: post.categories.length,
              itemBuilder: (BuildContext context, int index) => Row(
                    children: [
                      CategoryTab(
                        category: post.categories[index],
                        textFontSize: mediaQuery.size.width * 0.035,
                      ),
                      SizedBox(width: mediaQuery.size.width * 0.02),
                    ],
                  )),
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: mediaQuery.size.height * 0.60),
        child: SizedBox(
          height: mediaQuery.size.width * 1.20,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.03),

                  /// Title
                  FittedBox(
                    child: Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: kNavyBlueColour,
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),

                  /// Categories
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.10),
                    child: buildCategoryRow(),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.04),

                  /// Pin row
                  Obx(() => postController.isPostOwner.value
                      ? Container()
                      : Column(
                          children: [
                            buildPinRow(),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                          ],
                        )),

                  /// Visit row
                  Obx(() => postController.isPostOwner.value
                      ? Container()
                      : Column(
                          children: [
                            buildVisitRow(),
                            SizedBox(height: mediaQuery.size.height * 0.03),
                          ],
                        )),

                  /// Delete POST button
                  Obx(() => postController.isPostOwner.value
                      ? Column(
                          children: [
                            RoundedButton(
                              buttonText: "Delete Post",
                              buttonColour: Colors.red,
                              buttonFontSize: mediaQuery.size.width * 0.04,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return PopUpDialog(
                                    dialogContext: dialogContext,
                                    function: () => postController.deletePost(),
                                    description: 'Delete?',
                                    noColourButtonText: 'No',
                                    colourButtonText: 'Yes',
                                    buttonColour: Colors.red,
                                    icon: Icon(
                                      FontAwesomeIcons.solidTrashCan,
                                      color: Colors.white,
                                      size: mediaQuery.size.width * 0.15,
                                    ),
                                    circularImageColour: Colors.red,
                                  );
                                },
                              ),
                              buttonHeight: mediaQuery.size.width * 0.12,
                              buttonLength: mediaQuery.size.width * 0.5,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.03),
                          ],
                        )
                      : Container()),

                  /// POST OWNER profile info
                  Obx(() =>
                      authController.firestoreUser.value!.id == post.ownerId
                          ? Container()
                          : PostOwnerInfo(
                              post: post,
                              circleAvatarSize: mediaQuery.size.width * 0.10,
                              profileIconSize: mediaQuery.size.width * 0.08,
                              sizedBoxWidth: mediaQuery.size.width * 0.04,
                              textStyle: GoogleFonts.poppins(
                                fontSize: mediaQuery.size.width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),

                  SizedBox(height: mediaQuery.size.height * 0.04),

                  /// Description
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.10),
                    child: Text(
                      post.description,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                      ),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.03),

                  /// Google Maps
                  buildGoogleMapWidget(),
                  SizedBox(height: mediaQuery.size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      );
    }

    /// Build the UI for the round Recommendation indicator
    Widget buildMoreImagesIndicator() {
      return Positioned(
        top: mediaQuery.size.width * 0.50,
        right: mediaQuery.size.width * 0.02,
        child: CircleAvatar(
          radius: mediaQuery.size.width * 0.04,
          backgroundColor: kNavyBlueColour,
          child: Icon(
            FontAwesomeIcons.chevronRight,
            size: mediaQuery.size.width * 0.04,
            color: Colors.white,
          ),
        ),
      );
    }

    /// Build post image(s)
    Widget buildImages() {
      return SizedBox(
        height: mediaQuery.size.height * 0.63,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: post.imageUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                width: mediaQuery.size.width,
                imageUrl: post.imageUrls[index],
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.all(
                    mediaQuery.size.width * 0.05,
                  ),
                  child: circularProgressIndicator(),
                ),
              );
            }),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          buildImages(),
          post.imageUrls.length != 1 ? buildMoreImagesIndicator() : Container(),
          buildInformationSection(),
          buildRoundRecommendationIndicator(),
          const CircleBackButton(),
        ],
      ),
    );
  }
}
