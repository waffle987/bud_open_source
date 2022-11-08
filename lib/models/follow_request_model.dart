import 'package:cloud_firestore/cloud_firestore.dart';

class FollowRequestModel {
  final String requestingUserId;
  final String requestingPhotoUrl;
  final String requestingUsername;
  final Timestamp timestamp;

  FollowRequestModel({
    required this.requestingUserId,
    required this.requestingPhotoUrl,
    required this.requestingUsername,
    required this.timestamp,
  });

  factory FollowRequestModel.fromDocument({required DocumentSnapshot doc}) {
    return FollowRequestModel(
      requestingUserId: doc['requestingUserId'],
      requestingPhotoUrl: doc['requestingPhotoUrl'],
      requestingUsername: doc['requestingUsername'],
      timestamp: doc['timestamp'],
    );
  }
}
