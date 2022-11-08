import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/config.dart';
import 'package:bud/general/counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';

class PostController extends GetxController {
  final PostModel post;
  final bool isPost;

  PostController({
    required this.post,
    required this.isPost,
  });

  /// Stored values
  final RxInt pinCount = RxInt(0);
  final RxInt visitCount = RxInt(0);
  final RxBool isPinned = RxBool(false);
  final RxBool isVisited = RxBool(false);
  final RxBool isPostOwner = RxBool(false);

  /// GetX controllers
  final AuthController authController = AuthController.to;

  /// Firestore collection references
  final CollectionReference _postsCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  @override
  void onInit() async {
    final String currentUserId = authController.firestoreUser.value!.id;

    /// Case: Is owner of POST
    if (currentUserId == post.ownerId) {
      isPostOwner.value = true;
    } else {
      /// Case: POST
      if (isPost) {
        /// Get Pin and Visit counts
        pinCount.value = getCount(map: post.pins);
        visitCount.value = getCount(map: post.visits);

        /// Get pinned and visited values
        isPinned.value = post.pins[currentUserId] == true;
        isVisited.value = post.visits[currentUserId] == true;
      }

      /// Case: PIN
      else {
        isPinned.value = true;
        isVisited.value = post.visits[currentUserId] == true;

        /// Get POST stats from original POST
        await getPostStats();
      }
    }

    super.onInit();
  }

  /// Get ORIGINAL POST stats
  Future<void> getPostStats() async {
    final String postOwnerId = post.ownerId;
    final String postId = post.postId;

    /// Get original post from Firestore
    DocumentSnapshot postDoc = await _postsCollectionReference
        .doc(postOwnerId)
        .collection("posts")
        .doc(postId)
        .get();

    PostModel originalPostModel = PostModel.fromDocument(doc: postDoc);

    /// Get the post stats
    pinCount.value = getCount(map: originalPostModel.pins);
    visitCount.value = getCount(map: originalPostModel.visits);
  }

  /// PIN post
  void pinPost() {
    /// Generate IDs
    final String currentUserId = authController.firestoreUser.value!.id;
    final String postOwnerId = post.ownerId;
    final String postId = post.postId;

    /// Update values
    isPinned.value = true;
    pinCount.value = pinCount.value + 1;

    /// Update PIN count for current post
    _postsCollectionReference
        .doc(postOwnerId)
        .collection("posts")
        .doc(postId)
        .update({"pins.$currentUserId": true});

    /// Upload PIN to current user PINS section
    _postsCollectionReference
        .doc(currentUserId)
        .collection("pins")
        .doc(postId)
        .set({
      "userId": currentUserId,
      "postId": postId,
      "name": post.title,
      "description": post.description,
      "position": post.position,
      "recommendation": post.recommendation,
      "photoUrls": post.imageUrls,
      "categories": post.categories,
      "visits": {},
      "pins": {},
      "timestamp": DateTime.now(),
    });

    Get.snackbar(
      'Pinned'.tr,
      "Added to your Board",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      backgroundColor: Colors.pinkAccent,
      colorText: Colors.white,
    );
  }

  /// UNPIN post
  void unpinPost() {
    /// Generate IDs
    final String currentUserId = authController.firestoreUser.value!.id;
    final String postOwnerId = post.ownerId;
    final String postId = post.postId;

    /// Update values
    isPinned.value = false;
    pinCount.value = pinCount.value - 1;

    /// Update PIN count for original post
    _postsCollectionReference
        .doc(postOwnerId)
        .collection("posts")
        .doc(postId)
        .update({"pins.$currentUserId": false});

    /// Delete PIN
    _postsCollectionReference
        .doc(currentUserId)
        .collection("pins")
        .doc(postId)
        .delete();

    /// If it is a PIN then pop the Post Page off
    if (!isPost) {
      Get.back();
    }

    Get.snackbar(
      'Unpinned'.tr,
      "Removed from your Board",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );
  }

  /// VISIT
  void visit() {
    /// Generate IDs
    final String currentUserId = authController.firestoreUser.value!.id;
    final String postOwnerId = post.ownerId;
    final String postId = post.postId;

    /// Update values
    isVisited.value = true;
    visitCount.value = visitCount.value + 1;

    /// Update VISIT count for original post
    _postsCollectionReference
        .doc(postOwnerId)
        .collection("posts")
        .doc(postId)
        .update({"visits.$currentUserId": true});

    if (!isPost) {
      /// Update VISIT count for pin
      _postsCollectionReference
          .doc(postOwnerId)
          .collection("pins")
          .doc(postId)
          .update({"visits.$currentUserId": true});
    }

    Get.snackbar(
      'Visited'.tr,
      "Shared your visit",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );
  }

  /// UNVISIT
  void unvisit() {
    /// Generate IDs
    final String currentUserId = authController.firestoreUser.value!.id;
    final String postOwnerId = post.ownerId;
    final String postId = post.postId;

    /// Update values
    isVisited.value = false;
    visitCount.value = visitCount.value - 1;

    /// Update PIN count for original post
    _postsCollectionReference
        .doc(postOwnerId)
        .collection("posts")
        .doc(postId)
        .update({"visits.$currentUserId": false});

    if (!isPost) {
      /// Update VISIT count for pin
      _postsCollectionReference
          .doc(postOwnerId)
          .collection("pins")
          .doc(postId)
          .update({"visits.$currentUserId": false});
    }
  }

  /// Delete POST
  void deletePost() {
    final String currentUserId = authController.firestoreUser.value!.id;
    final String postId = post.postId;

    _postsCollectionReference
        .doc(currentUserId)
        .collection("posts")
        .doc(postId)
        .delete();

    Get.back();

    Get.snackbar(
      'Deleted'.tr,
      "You have deleted your Post",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );
  }
}
