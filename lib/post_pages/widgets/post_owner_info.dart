import 'package:bud/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../general/config.dart';
import '../../models/user_model.dart';
import '../../profile_pages/controllers/profile_post_controller.dart';

class PostOwnerInfo extends StatelessWidget {
  final PostModel post;
  final double circleAvatarSize;
  final double profileIconSize;
  final double sizedBoxWidth;
  final TextStyle textStyle;
  final MainAxisAlignment mainAxisAlignment;

  const PostOwnerInfo({
    Key? key,
    required this.post,
    required this.circleAvatarSize,
    required this.profileIconSize,
    required this.sizedBoxWidth,
    required this.textStyle,
    required this.mainAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// GetX controllers
    final ProfilePostController profilePostController =
        Get.put<ProfilePostController>(
            ProfilePostController(profileId: post.ownerId));

    return FutureBuilder<UserModel>(
        future:
            profilePostController.getUserProfile(postProfileId: post.ownerId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          UserModel? userModel = snapshot.data;

          return userModel != null
              ? Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: [
                    CircleAvatar(
                      radius: circleAvatarSize,
                      backgroundColor: kNavyBlueColour,
                      backgroundImage: userModel.photoUrl == ''
                          ? null
                          : CachedNetworkImageProvider(userModel.photoUrl),
                      child: userModel.photoUrl == ''
                          ? Icon(
                              FontAwesomeIcons.solidUser,
                              size: profileIconSize,
                              color: Colors.white,
                            )
                          : Container(),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Text(
                      userModel.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ],
                )
              : Container();
        });
  }
}
