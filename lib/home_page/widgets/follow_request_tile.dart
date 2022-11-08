import 'package:bud/general/widgets/rounded_button.dart';
import 'package:bud/models/follow_request_model.dart';
import 'package:bud/social_pages/controllers/social_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../general/config.dart';

class FollowRequestTile extends StatelessWidget {
  final FollowRequestModel followRequest;

  const FollowRequestTile({
    Key? key,
    required this.followRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final SocialController socialController = SocialController.to;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: kNavyBlueColour,
        backgroundImage: followRequest.requestingPhotoUrl != ''
            ? CachedNetworkImageProvider(followRequest.requestingPhotoUrl)
            : null,
        child: followRequest.requestingPhotoUrl != ''
            ? null
            : const Icon(
                FontAwesomeIcons.solidUser,
                color: Colors.white,
              ),
      ),
      title: Text(
        followRequest.requestingUsername,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: GestureDetector(
        onTap: () =>
            socialController.ignoreFriendRequest(followRequest: followRequest),
        child: const Text(
          'Ignore Request',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13.0,
          ),
        ),
      ),
      trailing: RoundedButton(
        buttonText: "Accept",
        buttonColour: kPrimaryAccentColour,
        buttonFontSize: mediaQuery.size.width * 0.035,
        onPressed: () =>
            socialController.acceptFriendRequest(followRequest: followRequest),
        buttonHeight: mediaQuery.size.width * 0.09,
        buttonLength: mediaQuery.size.width * 0.30,
      ),
    );
  }
}
