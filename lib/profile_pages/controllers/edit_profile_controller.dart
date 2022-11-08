import 'package:bud/general/controllers/image_picker_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../authentication/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  /// Text editing controllers
  final TextEditingController usernameTextEditingController =
      TextEditingController();
  final TextEditingController bioTextEditingController =
      TextEditingController();

  /// GetX controllers
  final AuthController authController = AuthController.to;
  final ImagePickerController imagePickerController = ImagePickerController.to;

  /// Firestore collection references
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  /// Check if username exists
  Future<bool> checkIfUsernameExists() async {
    QuerySnapshot userDoc = await _usersCollectionReference
        .where("username", isEqualTo: usernameTextEditingController.text)
        .get();

    return userDoc.docs.isNotEmpty;
  }

  /// Update Firestore with new profile information
  void updateUsername() {
    final String currentUserId = authController.firestoreUser.value!.id;

    _usersCollectionReference
        .doc(currentUserId)
        .update({"username": usernameTextEditingController.text});

    usernameTextEditingController.clear();
  }

  void updateBio() {
    final String currentUserId = authController.firestoreUser.value!.id;

    _usersCollectionReference
        .doc(currentUserId)
        .update({"bio": bioTextEditingController.text});

    bioTextEditingController.clear();
  }

  void updateProfilePicture() async {
    final String currentUserId = authController.firestoreUser.value!.id;

    /// Upload image to Firebase Storage
    await imagePickerController.uploadProfileImage();

    _usersCollectionReference
        .doc(currentUserId)
        .update({"photoUrl": imagePickerController.imageUrl.value});
  }
}
