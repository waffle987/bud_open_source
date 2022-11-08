import 'dart:async';

import 'package:bud/authentication/controllers/auth_controller.dart';
import 'package:bud/general/config.dart';
import 'package:bud/models/follow_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';

class SocialController extends GetxController {
  static SocialController to = Get.find();

  Rxn<List<FollowRequestModel>> requestList = Rxn<List<FollowRequestModel>>();

  /// GetX controllers
  final AuthController authController = AuthController.to;

  /// Collection references
  final CollectionReference _socialCollectionReference =
      FirebaseFirestore.instance.collection('social');
  final CollectionReference _userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  /// Stream controllers
  final StreamController<List<FollowRequestModel>>
      _followRequestStreamController =
      StreamController<List<FollowRequestModel>>.broadcast();

  /// Text Editing Controllers
  final TextEditingController usernameTextController = TextEditingController();

  @override
  void onInit() {
    requestList.bindStream(listenToFollowRequestRealTime());

    super.onInit();
  }

  /// Stream of follow requests
  Stream<List<FollowRequestModel>> listenToFollowRequestRealTime() {
    final currentUserId = authController.firebaseUser.value!.uid;

    _socialCollectionReference
        .doc(currentUserId)
        .collection('requests')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((requestSnapshot) {
      if (requestSnapshot.docs.isNotEmpty) {
        List<FollowRequestModel> requests = requestSnapshot.docs.length == 0
            ? []
            : requestSnapshot.docs
                .map((doc) => FollowRequestModel.fromDocument(doc: doc))
                .toList();
        _followRequestStreamController.add(requests);
      } else {
        _followRequestStreamController.add([]);
      }
    });

    return _followRequestStreamController.stream;
  }

  /// SEND follow request
  void sendFollowRequest() async {
    if (usernameTextController.text.isNotEmpty) {
      /// Get User ID of RECEIVING user
      QuerySnapshot querySnapshot = await _userCollectionReference
          .where("username", isEqualTo: usernameTextController.text)
          .get();

      if (querySnapshot.size == 1) {
        final UserModel currentUser = authController.firestoreUser.value!;
        final UserModel receivingUser =
            UserModel.fromDocument(doc: querySnapshot.docs[0]);

        /// Get request document snapshot from Firestore to see if it exists
        final DocumentSnapshot requestSnapshot =
            await _socialCollectionReference
                .doc(receivingUser.id)
                .collection('requests')
                .doc(currentUser.id)
                .get();

        if (!requestSnapshot.exists) {
          _socialCollectionReference
              .doc(receivingUser.id)
              .collection('requests')
              .doc(currentUser.id)
              .set({
            "requestingUserId": currentUser.id,
            "requestingPhotoUrl": currentUser.photoUrl,
            "requestingUsername": currentUser.username,
            "timestamp": DateTime.now(),
          });

          usernameTextController.clear();

          Get.back();

          Get.snackbar(
            'Request Sent ✅'.tr,
            'Successfully sent a Follow Request',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          /// Request already sent
          usernameTextController.clear();

          Get.snackbar(
            'Already Sent'.tr,
            'You have already sent a request',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: kPrimaryAccentColour,
            colorText: Colors.white,
          );
        }
      } else {
        /// Invalid Username entered
        usernameTextController.clear();

        Get.snackbar(
          'Invalid'.tr,
          'This username does not exist (Note: Case sensitive)',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      /// No Username entered
      Get.snackbar(
        'No Username entered'.tr,
        'Please enter a Username to send a follow request',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// IGNORE follow request
  void ignoreFriendRequest({required FollowRequestModel followRequest}) {
    final UserModel currentUserModel = authController.firestoreUser.value!;

    /// Delete follow request
    _socialCollectionReference
        .doc(currentUserModel.id)
        .collection('requests')
        .doc(followRequest.requestingUserId)
        .delete();

    Get.snackbar(
      'Ignored Request'.tr,
      'You ignored ${followRequest.requestingUsername} request',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );
  }

  /// ACCEPT follow request
  void acceptFriendRequest({required FollowRequestModel followRequest}) async {
    final UserModel currentUserModel = authController.firestoreUser.value!;

    /// Delete follow request
    _socialCollectionReference
        .doc(currentUserModel.id)
        .collection('requests')
        .doc(followRequest.requestingUserId)
        .delete();

    /// Add REQUESTER to current User's FOLLOWING
    _socialCollectionReference
        .doc(currentUserModel.id)
        .collection('followers')
        .doc(followRequest.requestingUserId)
        .set({});

    /// Add current User to REQUESTER'S FOLLOWING
    _socialCollectionReference
        .doc(followRequest.requestingUserId)
        .collection('following')
        .doc(currentUserModel.id)
        .set({});

    Get.snackbar(
      'Accepted Request ✅'.tr,
      'You accepted ${followRequest.requestingUsername} request!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: kPrimaryAccentColour,
      colorText: Colors.white,
    );
  }
}
