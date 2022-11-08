import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String phoneNumber;
  final String bio;
  final String photoUrl;
  final String tag;

  UserModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.bio,
    required this.photoUrl,
    required this.tag,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        phoneNumber = data['phoneNumber'],
        photoUrl = data['photoUrl'],
        username = data['username'],
        bio = data['bio'],
        tag = data['tag'];

  factory UserModel.fromDocument({required DocumentSnapshot doc}) {
    return UserModel(
      id: doc['id'],
      phoneNumber: doc['phoneNumber'],
      photoUrl: doc['photoUrl'],
      username: doc['username'],
      bio: doc['bio'],
      tag: doc['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'username': username,
      'bio': bio,
      'tag': tag,
    };
  }

  Map<String, dynamic> data({required UserModel user}) {
    return {
      'id': user.id,
      'phoneNumber': user.phoneNumber,
      'photoUrl': user.photoUrl,
      'username': user.username,
      'bio': user.bio,
      'tag': user.tag,
    };
  }
}
