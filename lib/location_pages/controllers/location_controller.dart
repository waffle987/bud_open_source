import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/api_keys.dart';
import 'package:bud/models/google_places_details_model.dart';
import 'package:bud/services/http_request_service.dart';
import 'package:bud/social_pages/controllers/social_feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../general/config.dart';
import '../../models/google_places_predictions_model.dart';

class LocationController extends GetxController {
  static LocationController to = Get.find();

  final RxnDouble latitude = RxnDouble();
  final RxnDouble longitude = RxnDouble();

  final Rxn<List<GooglePlacesPredictionModel>> predictionsList =
      Rxn<List<GooglePlacesPredictionModel>>();
  final Rxn<GoogleMapController> googleMapController =
      Rxn<GoogleMapController>();

  /// Instantiate 3rd party packages
  final Location location = Location();
  final GeoFlutterFire geoFlutterFire = GeoFlutterFire();

  /// GetX controllers
  final AuthController authController = AuthController.to;
  late final SocialFeedController socialFeedController =
      SocialFeedController.to;

  /// Text editing controllers
  final TextEditingController locationQueryTextController =
      TextEditingController();

  @override
  void onInit() async {
    /// Check current permission status
    PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      /// Request location permission from USER
      await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted ||
          permissionGranted != PermissionStatus.grantedLimited) {
        Get.snackbar(
          'No Permission'.tr,
          "Please enable location permissions to post",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: kPrimaryAccentColour,
          colorText: Colors.white,
        );
      }
    }

    super.onInit();
  }

  @override
  void onReady() async {
    try {
      LocationData locationData = await location.getLocation();

      latitude.value = locationData.latitude!;

      longitude.value = locationData.longitude!;
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    super.onReady();
  }

  /// Get query predictions from Google Maps Platform
  void searchPlace({required String placeQuery}) async {
    /// Check if a query has been entered
    if (locationQueryTextController.text.isNotEmpty) {
      final String sessionId = const Uuid().v4();

      final String predictionRequestUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json"
          "?input=$placeQuery"
          "&sessiontoken=$sessionId"
          "&key=${ApiKeys.googleCloudApi}";

      var response =
          await HttpRequestService.getRequest(url: predictionRequestUrl);

      /// Error message if Request FAILS
      if (response == "Failed Request") {
        Get.snackbar(
          'Error'.tr,
          "Please try again",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      /// Retrieve Predictions if Request SUCCEEDS
      if (response["status"] == "OK") {
        var googlePlacesPredictionsJson = response["predictions"];

        List<GooglePlacesPredictionModel> predictionList =
            (googlePlacesPredictionsJson as List)
                .map((predictions) =>
                    GooglePlacesPredictionModel.fromJson(json: predictions))
                .toList();

        /// Update prediction list value
        predictionsList.value = predictionList;
      }
    }
  }

  /// Get Places details from Google Maps Platform
  void getPlaceDetails({
    required String placeId,
    required bool isSearchFeed,
  }) async {
    final String sessionId = const Uuid().v4();

    final String placesDetailsRequestUrl =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&sessiontoken=$sessionId"
        "&key=${ApiKeys.googleCloudApi}";

    var response =
        await HttpRequestService.getRequest(url: placesDetailsRequestUrl);

    /// Error message if Request FAILS
    if (response == "Failed Request") {
      Get.snackbar(
        'Error'.tr,
        "Please try again",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    /// Retrieve Predictions if Request SUCCEEDS
    if (response["status"] == "OK") {
      var googlePlacesDetailsJson = response["result"];

      GooglePlacesDetailsModel detailsModel = GooglePlacesDetailsModel.fromJson(
        json: googlePlacesDetailsJson,
        placeId2: placeId,
      );

      if (isSearchFeed) {
        final GeoFirePoint geoFirePoint = GeoFirePoint(
          detailsModel.latitude,
          detailsModel.longitude,
        );

        socialFeedController.searchFeedPost(geoFirePoint: geoFirePoint);
      } else {
        /// Update longitude and latitude values
        latitude.value = detailsModel.latitude;
        longitude.value = detailsModel.longitude;

        if (googleMapController.value != null) {
          final LatLng newLatLng = LatLng(
            detailsModel.latitude,
            detailsModel.longitude,
          );

          googleMapController.value!
              .animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newLatLng,
              zoom: 15,
            ),
          ));
        }
      }

      /// Pop off Location Search Page
      Get.back();
    }
  }
}
