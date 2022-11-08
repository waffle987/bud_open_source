import 'package:bud/location_pages/controllers/location_controller.dart';
import 'package:bud/location_pages/widgets/location_search_tile.dart';
import 'package:bud/models/google_places_predictions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationSearchFeed extends StatelessWidget {
  final bool isSearchFeed;

  const LocationSearchFeed({
    Key? key,
    required this.isSearchFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final LocationController locationController = LocationController.to;

    return Obx(
      () {
        List<GooglePlacesPredictionModel>? feedInfo =
            locationController.predictionsList.value;

        return feedInfo != null && feedInfo.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(
                  left: mediaQuery.size.width * 0.06,
                  right: mediaQuery.size.width * 0.06,
                  top: mediaQuery.size.width * 0.06,
                  bottom: mediaQuery.size.width * 0.10,
                ),
                shrinkWrap: true,
                itemCount: feedInfo.length,
                itemBuilder: (_, index) => LocationSearchTile(
                  predictionModel: feedInfo[index],
                  isSearchFeed: isSearchFeed,
                ),
              )
            : Container();
      },
    );
  }
}
