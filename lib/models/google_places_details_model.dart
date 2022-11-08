class GooglePlacesDetailsModel {
  final String placeId;
  final double latitude;
  final double longitude;

  GooglePlacesDetailsModel({
    required this.placeId,
    required this.latitude,
    required this.longitude,
  });

  GooglePlacesDetailsModel.fromJson({
    required Map<String, dynamic> json,
    required String placeId2,
  })  : placeId = placeId2,
        latitude = json["geometry"]["location"]["lat"],
        longitude = json["geometry"]["location"]["lng"];
}
