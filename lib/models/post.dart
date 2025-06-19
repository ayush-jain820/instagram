import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  // final String postUrl;
  // final String profileImage;
  final List likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    // required this.postUrl,
    // required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "description": description,
      "uid": uid,
      "username": username,
      "postId": postId,
      "datePublished": datePublished,
      // "postUrl": postUrl,
      // "profileImage": profileImage,
      "likes": likes,
    };
  }

  static Post fromSnap(DocumentSnapshot docsnap) {
    var snapshot = docsnap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      // postUrl: snapshot['postUrl'],
      // profileImage: snapshot['profileImage'],
      likes: List<String>.from(snapshot['likes']),
    );
  }
}
