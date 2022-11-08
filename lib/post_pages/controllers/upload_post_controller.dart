import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../authentication/controllers/auth_controller.dart';
import '../../general/config.dart';
import '../../general/controllers/image_picker_controller.dart';
import '../../location_pages/controllers/location_controller.dart';

class UploadPostController extends GetxController {
  static UploadPostController to = Get.find();

  final RxString recommendation = RxString("");
  final RxList<String> categoryList = RxList<String>([]);
  final RxBool isLoading = RxBool(false);

  /// GetX controllers
  final AuthController authController = AuthController.to;
  final LocationController locationController = LocationController.to;
  final ImagePickerController imagePickerController = ImagePickerController.to;

  /// Firestore collection references
  final CollectionReference _postsCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  /// Text editing controllers
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();

  /// Add the category to the Category List
  void updateCategoryList({required String category}) {
    if (!categoryList.contains(category)) {
      categoryList.add(category);
    }
  }

  /// Remove category from Category List
  void removeCategory({required String category}) {
    categoryList.remove(category);
  }

  /// Reset stored values
  void clearValues() {
    locationController.latitude.value = 0.0;
    locationController.longitude.value = 0.0;
    nameTextEditingController.clear();
    descriptionTextEditingController.clear();
    recommendation.value = "";
    imagePickerController.imageUrls.value!.clear();
    imagePickerController.selectedImages.value!.clear();
  }

  /// Upload POST to Firestore
  void uploadPostToFirestore({required String postId}) async {
    if (locationController.latitude.value != 0.0 &&
        locationController.longitude.value != 0.0 &&
        nameTextEditingController.text.isNotEmpty &&
        descriptionTextEditingController.text.isNotEmpty &&
        recommendation.value != "" &&
        imagePickerController.imageUrls.value!.isNotEmpty &&
        categoryList.isNotEmpty) {
      /// Upload to Firebase Storage
      await uploadImagesToFirebaseStorage(postId: postId);

      /// Create GeoFirePoint to upload to Firestore
      GeoFirePoint userLocation = locationController.geoFlutterFire.point(
        latitude: locationController.latitude.value!,
        longitude: locationController.longitude.value!,
      );

      /// Generate IDs
      final String currentUserId = authController.firestoreUser.value!.id;

      /// Upload to Firestore
      _postsCollectionReference
          .doc(currentUserId)
          .collection("posts")
          .doc(postId)
          .set({
        "userId": currentUserId,
        "postId": postId,
        "name": nameTextEditingController.text,
        "description": descriptionTextEditingController.text,
        "position": userLocation.data,
        "recommendation": recommendation.value,
        "photoUrls": imagePickerController.imageUrls.value,
        "categories": categoryList,
        "visits": {},
        "pins": {},
        "timestamp": DateTime.now(),
      });

      /// Reset values
      clearValues();

      Get.back();

      Get.snackbar(
        'Posted'.tr,
        "Successfully posted!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Oops empty fields'.tr,
        "Please try again!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Upload Images to Firebase Storage
  Future<void> uploadImagesToFirebaseStorage({required String postId}) async {
    if (imagePickerController.selectedImages.value!.isNotEmpty) {
      await imagePickerController.uploadPostImages(postId: postId);
    }
  }

  /// Upload location-based post
  void postRecommendation() async {
    /// Begin loading
    isLoading.value = true;

    /// Generate postId
    final String postId = const Uuid().v4();

    /// Check current permission status
    PermissionStatus permissionGranted =
        await locationController.location.hasPermission();

    /// Case: NO permission
    if (permissionGranted == PermissionStatus.denied) {
      /// Request location permission from USER
      await locationController.location.requestPermission();

      if (permissionGranted == PermissionStatus.granted) {
        /// Upload to Firestore
        uploadPostToFirestore(postId: postId);
      } else {
        Get.snackbar(
          'No Permission'.tr,
          "Please enable location permissions to post",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: kPrimaryAccentColour,
          colorText: Colors.white,
        );
      }
    }

    /// Case: HAVE permission
    else {
      /// Upload to Firebase Storage
      await uploadImagesToFirebaseStorage(postId: postId);

      /// Upload to Firestore
      uploadPostToFirestore(postId: postId);
    }

    /// Exit loading
    isLoading.value = false;
  }
}
