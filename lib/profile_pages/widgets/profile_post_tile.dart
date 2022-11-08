import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/models/post_model.dart';
import 'package:bud/post_pages/ui/post_page.dart';
import 'package:bud/post_pages/widgets/post_owner_info.dart';
import 'package:bud/post_pages/widgets/recommendation_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';
import '../../general/widgets/progress_indicators.dart';
import '../../post_pages/widgets/category_tab.dart';

class ProfilePostTile extends StatelessWidget {
  final PostModel post;
  final bool isPost;

  const ProfilePostTile({
    Key? key,
    required this.post,
    required this.isPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final AuthController authController = AuthController.to;

    /// Build image
    Widget buildImage() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 0.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: post.imageUrls.isEmpty
              ? Container()
              : CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  height: mediaQuery.size.width * 0.50,
                  imageUrl: post.imageUrls[0],
                  placeholder: (context, url) => Padding(
                    padding: EdgeInsets.all(
                      mediaQuery.size.width * 0.05,
                    ),
                    child: circularProgressIndicator(),
                  ),
                ),
        ),
      );
    }

    /// Build Categories row
    Widget buildCategoryRow() {
      return SizedBox(
        height: mediaQuery.size.height * 0.03,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: post.categories.length,
            itemBuilder: (BuildContext context, int index) => Row(
                  children: [
                    CategoryTab(
                      category: post.categories[index],
                      textFontSize: mediaQuery.size.width * 0.02,
                    ),
                    SizedBox(width: mediaQuery.size.width * 0.02),
                  ],
                )),
      );
    }

    return GestureDetector(
      /// Push to post page
      onTap: () => Get.to(() => PostPage(
            post: post,
            isPost: isPost,
          )),
      child: Row(
        children: [
          Flexible(
            flex: 45,
            child: Stack(
              children: [
                buildImage(),
                RecommendationIndicator(
                  post: post,
                  radius: mediaQuery.size.width * 0.05,
                ),
              ],
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.05),
          Flexible(
            flex: 55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: mediaQuery.size.width * 0.04,
                    fontWeight: FontWeight.w700,
                    color: kNavyBlueColour,
                  ),
                ),
                SizedBox(height: mediaQuery.size.width * 0.02),
                buildCategoryRow(),
                SizedBox(height: mediaQuery.size.width * 0.03),
                Obx(() => authController.firestoreUser.value!.id == post.ownerId
                    ? Container()
                    : PostOwnerInfo(
                        post: post,
                        circleAvatarSize: mediaQuery.size.width * 0.04,
                        profileIconSize: mediaQuery.size.width * 0.02,
                        sizedBoxWidth: mediaQuery.size.width * 0.02,
                        textStyle: GoogleFonts.poppins(
                          fontSize: mediaQuery.size.width * 0.028,
                        ),
                        mainAxisAlignment: MainAxisAlignment.start,
                      )),
                SizedBox(height: mediaQuery.size.width * 0.03),
                Text(
                  post.description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: mediaQuery.size.width * 0.025,
                    color: kGreyColour,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
