import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../authentication/controllers/auth_controller.dart';

class CloudStorageService {
  /// GetX controllers
  final AuthController authController = AuthController.to;

  /// UPLOAD PROFILE image to Firebase Storage
  Future<CloudStorageResult> uploadProfileImage(
      {required File imageToUpload}) async {
    final String currentUserId = authController.firestoreUser.value!.id;

    final firebase_storage.Reference firebaseStorageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("profile pictures")
        .child(currentUserId);

    firebase_storage.TaskSnapshot taskSnapshot =
        await firebaseStorageRef.putFile(imageToUpload);

    if (taskSnapshot.state == firebase_storage.TaskState.success) {
      var imageUrl = await firebaseStorageRef.getDownloadURL();

      String downloadUrl = imageUrl.toString();

      return CloudStorageResult(
        imageUrl: downloadUrl,
        imageFileName: currentUserId,
      );
    } else {
      return CloudStorageResult(
        imageUrl: "",
        imageFileName: "",
      );
    }
  }

  /// UPLOAD POST image to Firebase Storage
  Future<CloudStorageResult> uploadPostImage({
    required File imageToUpload,
    required String imageId,
    required String postId,
  }) async {
    final firebase_storage.Reference firebaseStorageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(postId)
        .child(imageId);

    firebase_storage.TaskSnapshot taskSnapshot =
        await firebaseStorageRef.putFile(imageToUpload);

    if (taskSnapshot.state == firebase_storage.TaskState.success) {
      var imageUrl = await firebaseStorageRef.getDownloadURL();

      String downloadUrl = imageUrl.toString();

      return CloudStorageResult(
        imageUrl: downloadUrl,
        imageFileName: imageId,
      );
    } else {
      return CloudStorageResult(
        imageUrl: "",
        imageFileName: "",
      );
    }
  }

  /// DELETE POST image from Firebase Storage
  Future deleteImage({required String postId}) async {
    final firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(postId);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String? imageUrl;
  final String? imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
