import 'package:bud/models/google_places_predictions_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/location_controller.dart';

class LocationSearchTile extends StatelessWidget {
  final GooglePlacesPredictionModel predictionModel;
  final bool isSearchFeed;

  const LocationSearchTile({
    Key? key,
    required this.predictionModel,
    required this.isSearchFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final LocationController locationController = LocationController.to;

    return GestureDetector(
      onTap: () => locationController.getPlaceDetails(
        placeId: predictionModel.placeId,
        isSearchFeed: isSearchFeed,
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.locationDot,
              color: Colors.red,
            ),
            title: Text(
              predictionModel.mainText,
              style: GoogleFonts.poppins(
                fontSize: mediaQuery.size.width * 0.035,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: predictionModel.secondaryText != null
                ? Text(
                    predictionModel.secondaryText!,
                    style: TextStyle(fontSize: mediaQuery.size.width * 0.030),
                  )
                : null,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
