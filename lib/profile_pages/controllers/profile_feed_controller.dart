import 'dart:async';

import 'package:bud/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileFeedController extends GetxController {
  final String profileId;

  ProfileFeedController({required this.profileId});

  /// User "Posts" tab
  final Rxn<List<PostModel>> userPosts = Rxn<List<PostModel>>();

  /// User "Pin" tab
  final Rxn<List<PostModel>> userPins = Rxn<List<PostModel>>();

  /// Collection references
  final CollectionReference postCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  /// Stream controllers
  final StreamController<List<PostModel>> userPostStreamController =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<PostModel>> userPinStreamController =
      StreamController<List<PostModel>>.broadcast();

  @override
  void onInit() async {
    userPosts.bindStream(listenToUserPostsRealTime(currentUserId: profileId));

    userPins.bindStream(listenToUserPinsRealTime(currentUserId: profileId));
    super.onInit();
  }

  /// Listen to USER POSTS stream
  Stream<List<PostModel>> listenToUserPostsRealTime(
      {required String currentUserId}) {
    postCollectionReference
        .doc(currentUserId)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((postsSnapshot) {
      if (postsSnapshot.docs.isNotEmpty) {
        List<PostModel> userPosts = postsSnapshot.docs.isEmpty
            ? []
            : postsSnapshot.docs
                .map((doc) => PostModel.fromDocument(doc: doc))
                .toList();
        userPostStreamController.add(userPosts);
      } else {
        userPostStreamController.add([]);
      }
    });

    return userPostStreamController.stream;
  }

  /// Listen to USER PINS stream
  Stream<List<PostModel>> listenToUserPinsRealTime(
      {required String currentUserId}) {
    postCollectionReference
        .doc(currentUserId)
        .collection("pins")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((postsSnapshot) {
      if (postsSnapshot.docs.isNotEmpty) {
        List<PostModel> userPosts = postsSnapshot.docs.isEmpty
            ? []
            : postsSnapshot.docs
                .map((doc) => PostModel.fromDocument(doc: doc))
                .toList();
        userPinStreamController.add(userPosts);
      } else {
        userPinStreamController.add([]);
      }
    });

    return userPinStreamController.stream;
  }
}
