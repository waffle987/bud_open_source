import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String ownerId;
  final String postId;
  final String title;
  final String description;
  final String recommendation;
  final Map pins;
  final Map visits;
  final Map position;
  final List<dynamic> categories;
  final List<dynamic> imageUrls;
  final Timestamp timestamp;

  PostModel({
    required this.ownerId,
    required this.postId,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.position,
    required this.imageUrls,
    required this.categories,
    required this.pins,
    required this.visits,
    required this.timestamp,
  });

  factory PostModel.fromDocument({required DocumentSnapshot doc}) {
    return PostModel(
      ownerId: doc['userId'],
      postId: doc['postId'],
      title: doc['name'],
      description: doc['description'],
      recommendation: doc['recommendation'],
      position: doc['position'],
      imageUrls: List.from(doc['photoUrls']),
      categories: List.from(doc['categories']),
      pins: doc['pins'],
      visits: doc['visits'],
      timestamp: doc['timestamp'],
    );
  }
}
