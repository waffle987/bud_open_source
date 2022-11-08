class GooglePlacesPredictionModel {
  String placeId;
  String mainText;
  String? secondaryText;

  GooglePlacesPredictionModel({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  GooglePlacesPredictionModel.fromJson({required Map<String, dynamic> json})
      : placeId = json["place_id"],
        mainText = json["structured_formatting"]["main_text"],
        secondaryText = json["structured_formatting"]["secondary_text"];
}
