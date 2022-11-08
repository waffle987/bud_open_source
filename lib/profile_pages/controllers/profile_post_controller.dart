import 'package:bud/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfilePostController extends GetxController {
  final String profileId;

  ProfilePostController({required this.profileId});

  /// Firestore collection references
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  /// Get single USER profile
  Future<UserModel> getUserProfile({required String postProfileId}) async {
    DocumentSnapshot doc =
        await _usersCollectionReference.doc(postProfileId).get();

    return UserModel.fromDocument(doc: doc);
  }
}
