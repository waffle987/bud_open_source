import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../general/config.dart';
import '../../general/recommendations.dart';
import '../../models/post_model.dart';

class RecommendationIndicator extends StatelessWidget {
  final PostModel post;
  final double radius;

  const RecommendationIndicator({
    Key? key,
    required this.post,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// Build icon widget
    Widget buildIconWidget({
      required IconData iconData,
      required Color colour,
    }) {
      return Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.size.width * 0.02,
          left: mediaQuery.size.width * 0.02,
        ),
        child: CircleAvatar(
          backgroundColor: colour,
          radius: radius,
          child: Icon(
            iconData,
            color: Colors.white,
            size: radius,
          ),
        ),
      );
    }

    if (post.recommendation == Recommendations.thumbsUp) {
      return buildIconWidget(
        iconData: FontAwesomeIcons.solidThumbsUp,
        colour: kNavyBlueColour,
      );
    } else if (post.recommendation == Recommendations.happyFace) {
      return buildIconWidget(
        iconData: FontAwesomeIcons.solidFaceSmileBeam,
        colour: kPrimaryAccentColour,
      );
    } else if (post.recommendation == Recommendations.heart) {
      return buildIconWidget(
        iconData: FontAwesomeIcons.solidHeart,
        colour: Colors.pinkAccent,
      );
    } else if (post.recommendation == Recommendations.thumbsDown) {
      return buildIconWidget(
        iconData: FontAwesomeIcons.solidThumbsDown,
        colour: Colors.red,
      );
    } else {
      return Container();
    }
  }
}
