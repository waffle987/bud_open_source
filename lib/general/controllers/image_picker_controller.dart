import 'dart:io';

import 'package:bud/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../services/image_picker_service.dart';

class ImagePickerController extends GetxController {
  static ImagePickerController to = Get.find();

  /// For multiple images
  Rxn<List<XFile>> selectedImages = Rxn<List<XFile>>([]);
  Rxn<List<String>> imageUrls = Rxn<List<String>>([]);

  /// For single image
  Rxn<XFile> selectedImage = Rxn<XFile>();
  RxnString imageUrl = RxnString();

  /// Select single image from gallery (FOR PROFILE IMAGE)
  Future selectSingleImageFromGallery() async {
    XFile? tempImage = await ImageSelector().selectSingleImage();
    if (tempImage != null) {
      selectedImage.value = tempImage;
      update();
    } else {
      Get.snackbar(
        'Oops'.tr,
        "Please try again",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Upload images to Firebase Storage (FOR PROFILE IMAGE)
  Future<void> uploadProfileImage() async {
    final File imageToUpload = File(selectedImage.value!.path);

    /// Upload image to Firebase Storage
    CloudStorageResult cloudStorageResult =
        await CloudStorageService().uploadProfileImage(
      imageToUpload: imageToUpload,
    );

    /// Update imageUrl
    imageUrl.value = cloudStorageResult.imageUrl;
  }

  /// Select multiple images from gallery (FOR POSTS)
  Future selectMultipleImagesFromGallery() async {
    List<XFile>? tempImageList = await ImageSelector().selectMultipleImages();
    if (tempImageList != null) {
      selectedImages.value = tempImageList;
      update();
    } else {
      Get.snackbar(
        'Oops'.tr,
        "Please try again",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Upload images to Firebase Storage (FOR POST)
  Future<void> uploadPostImages({required String postId}) async {
    /// For loop for "selectedImages" list
    for (XFile image in selectedImages.value!) {
      final File imageToUpload = File(image.path);
      final String imageId = const Uuid().v4();

      /// Upload image to Firebase Storage
      CloudStorageResult cloudStorageResult =
          await CloudStorageService().uploadPostImage(
        imageToUpload: imageToUpload,
        postId: postId,
        imageId: imageId,
      );

      /// Add imageUrl to "imageUrls" list
      if (imageUrls.value != null) {
        imageUrls.value!.add(cloudStorageResult.imageUrl!);
      } else {
        imageUrls.value = [cloudStorageResult.imageUrl!];
      }
    }
  }
}
