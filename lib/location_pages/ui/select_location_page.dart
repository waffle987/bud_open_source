import 'package:bud/general/config.dart';
import 'package:bud/general/ui/loading_page.dart';
import 'package:bud/general/widgets/circle_back_button.dart';
import 'package:bud/general/widgets/rounded_button.dart';
import 'package:bud/location_pages/ui/search_location_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../general/controllers/image_picker_controller.dart';
import '../../post_pages/ui/upload_post_page.dart';
import '../controllers/location_controller.dart';

class SelectLocationPage extends StatelessWidget {
  const SelectLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    Get.put<ImagePickerController>(ImagePickerController());
    final LocationController locationController =
        Get.put<LocationController>(LocationController());

    /// Google Maps widget values
    final markers = <Marker>{};
    MarkerId markerId = const MarkerId("selected-location");

    /// Build Google Map Widget
    Widget buildGoogleMapWidget() {
      return Obx(
        () => locationController.latitude.value != null &&
                locationController.longitude.value != null
            ? GoogleMap(
                padding: EdgeInsets.only(
                  bottom: mediaQuery.size.height * 0.25,
                ),
                onMapCreated: (controller) =>
                    locationController.googleMapController.value = controller,
                zoomControlsEnabled: true,
                onCameraMove: (CameraPosition position) {
                  locationController.latitude.value = position.target.latitude;
                  locationController.longitude.value =
                      position.target.longitude;

                  markers.add(
                      Marker(markerId: markerId, position: position.target));
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    locationController.latitude.value!,
                    locationController.longitude.value!,
                  ),
                  zoom: 15,
                ),
                markers: markers,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              )
            : const LoadingPage(),
      );
    }

    /// Build info
    Widget buildInfo() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: mediaQuery.size.height * 0.20,
            width: mediaQuery.size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.05,
                vertical: mediaQuery.size.height * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Location",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: kNavyBlueColour,
                    ),
                  ),
                  Text(
                    'Drag to select the location of your recommendation',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: kGreyColour,
                    ),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.02),
                  Center(
                    child: RoundedButton(
                      buttonText: "Search",
                      iconWithSizedBox: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationDot,
                            color: Colors.white,
                          ),
                          SizedBox(width: mediaQuery.size.width * 0.015),
                        ],
                      ),
                      buttonColour: kPrimaryAccentColour,
                      buttonFontSize: mediaQuery.size.width * 0.035,
                      onPressed: () => Get.to(
                          () => const SearchLocationPage(isSearchFeed: false)),
                      buttonHeight: mediaQuery.size.width * 0.10,
                      buttonLength: mediaQuery.size.width * 0.40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      floatingActionButton: Obx(() =>
          locationController.latitude.value != null &&
                  locationController.longitude.value != null
              ? FloatingActionButton(
                  backgroundColor: kNavyBlueColour,
                  onPressed: () => Get.off(() => const UploadPostPage()),
                  child: const Icon(FontAwesomeIcons.arrowRight),
                )
              : Container()),
      body: Stack(
        children: [
          buildGoogleMapWidget(),
          buildInfo(),
          const CircleBackButton(),
        ],
      ),
    );
  }
}
