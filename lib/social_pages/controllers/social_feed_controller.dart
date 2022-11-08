import 'dart:async';

import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';

class SocialFeedController extends GetxController {
  static SocialFeedController to = Get.find();

  final RxnString feedSearchCategory = RxnString();
  final RxnBool isSearch = RxnBool(false);

  /// Default time-based feed
  final Rxn<List<PostModel>> userFeedPosts = Rxn<List<PostModel>>();

  /// Search-based feed
  final Rxn<List<PostModel>> userSearchPosts = Rxn<List<PostModel>>();

  /// Collection references
  final CollectionReference feedCollectionReference =
      FirebaseFirestore.instance.collection('feed');

  /// Stream controllers
  final StreamController<List<PostModel>> feedPostsStreamController =
      StreamController<List<PostModel>>.broadcast();

  /// GetX controllers
  final AuthController authController = AuthController.to;

  @override
  void onInit() async {
    userFeedPosts.bindStream(listenToUserFeedPostsRealTime());

    super.onInit();
  }

  /// Search USER FEED POSTS based on categories and location
  void searchFeedPost({required GeoFirePoint geoFirePoint}) {
    final String currentUserId = authController.firestoreUser.value!.id;
    final GeoFlutterFire geoFlutterFire = GeoFlutterFire();

    var collectionReference = feedSearchCategory.value != null &&
            feedSearchCategory.value!.isNotEmpty
        ? feedCollectionReference.doc(currentUserId).collection("posts").where(
              "categories",
              arrayContains: feedSearchCategory.value,
            )
        : feedCollectionReference.doc(currentUserId).collection("posts");

    Stream<List<DocumentSnapshot>> stream =
        geoFlutterFire.collection(collectionRef: collectionReference).within(
              center: geoFirePoint,
              radius: 1.5,
              field: "position",
            );

    stream.listen((List<DocumentSnapshot> documentList) {
      List<PostModel> postList = documentList.isNotEmpty
          ? documentList.map((doc) => PostModel.fromDocument(doc: doc)).toList()
          : [];

      /// Update Search Post List
      userSearchPosts.value = postList;

      /// Update isSearch to true
      isSearch.value = true;
    });
  }

  /// Reset to Default USER FEED
  void resetFeed() {
    feedSearchCategory.value = null;
    isSearch.value = false;
  }

  /// Listen to USER FEED POSTS stream
  Stream<List<PostModel>> listenToUserFeedPostsRealTime() {
    final String currentUserId = authController.firestoreUser.value!.id;

    feedCollectionReference
        .doc(currentUserId)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .limit(20)
        .snapshots()
        .listen((postsSnapshot) {
      if (postsSnapshot.docs.isNotEmpty) {
        List<PostModel> userPosts = postsSnapshot.docs.isEmpty
            ? []
            : postsSnapshot.docs
                .map((doc) => PostModel.fromDocument(doc: doc))
                .toList();
        feedPostsStreamController.add(userPosts);
      } else {
        feedPostsStreamController.add([]);
      }
    });

    return feedPostsStreamController.stream;
  }
}
