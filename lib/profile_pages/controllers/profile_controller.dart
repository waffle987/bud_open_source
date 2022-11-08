import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final String profileId;

  ProfileController({required this.profileId});

  final Rxn<int> followerCount = Rxn<int>(0);
  final Rxn<int> followingCount = Rxn<int>(0);

  /// Firestore collection references
  final CollectionReference _socialCollectionReference =
      FirebaseFirestore.instance.collection('social');

  @override
  void onInit() async {
    followerCount.bindStream(getFollowerCount());
    followingCount.bindStream(getFollowingCount());

    super.onInit();
  }

  /// Stream controllers
  final StreamController<int> followerCountStreamController =
      StreamController<int>.broadcast();
  final StreamController<int> followingCountStreamController =
      StreamController<int>.broadcast();

  /// Get FOLLOWER count
  Stream<int> getFollowerCount() {
    _socialCollectionReference
        .doc(profileId)
        .collection('followers')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        int followerCount = snapshot.docs.isEmpty ? 0 : snapshot.docs.length;
        followerCountStreamController.add(followerCount);
      } else {
        followerCountStreamController.add(0);
      }
    });

    return followerCountStreamController.stream;
  }

  /// Get FOLLOWING count
  Stream<int> getFollowingCount() {
    _socialCollectionReference
        .doc(profileId)
        .collection('following')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        int followingCount = snapshot.docs.isEmpty ? 0 : snapshot.docs.length;
        followingCountStreamController.add(followingCount);
      } else {
        followingCountStreamController.add(0);
      }
    });

    return followingCountStreamController.stream;
  }
}
