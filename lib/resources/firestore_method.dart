import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    /*Uint8List file,*/ String uid,
    String username,

    /* String ProfileImage,*/
  ) async {
    String res = " Some error occured";
    try {
      // String photoUrl = StorageMethods().uploadImagetoStorage(
      //   "posts",
      //   file ,
      //   true,
      // ) as String;
      String postId = Uuid().v1(); // Generate a unique post ID
      Post post = Post(
        description: description,
        uid: uid,
        username: username, // Use the passed username
        postId: postId,
        datePublished: DateTime.now(),
        // postUrl: photoUrl,
        // ProfileImage:  ProfileImage,// Replace with actual profile image URL
        likes: [],
      );
      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
 

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      print('Liking post: $postId by $uid');

      if (likes.contains(uid)) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .update({
              "likes": FieldValue.arrayRemove([uid]),
            });
      } else {
        await _firestore
            .collection("posts")
            .doc(postId)
            .update({
              "likes": FieldValue.arrayUnion([uid]),
            });
      }
    } catch (err) {
      print("Error liking post: ${err.toString()}");
    }
  }
 
  

 
}