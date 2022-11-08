import 'package:bud/general/widgets/circle_back_button.dart';
import 'package:bud/location_pages/controllers/location_controller.dart';
import 'package:bud/location_pages/widgets/location_search_feed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchLocationPage extends StatelessWidget {
  final bool isSearchFeed;

  const SearchLocationPage({
    Key? key,
    required this.isSearchFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final LocationController locationController = LocationController.to;

    /// Build location search bar
    Widget buildLocationSearchBar() {
      return Container(
        height: mediaQuery.size.height * 0.055,
        margin: EdgeInsets.only(
          right: mediaQuery.size.width * 0.05,
          left: mediaQuery.size.width * 0.20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: TextField(
            onChanged: (String textValue) =>
                locationController.searchPlace(placeQuery: textValue),
            controller: locationController.locationQueryTextController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search location",
              prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height * 0.02),
          child: Stack(
            children: [
              Column(
                children: [
                  buildLocationSearchBar(),
                  Expanded(
                      child: LocationSearchFeed(isSearchFeed: isSearchFeed)),
                ],
              ),
              const CircleBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}
