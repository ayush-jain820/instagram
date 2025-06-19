import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens/comments.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/likeanimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool islikeanimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final List likes = widget.snap['likes'] ?? [];
    final String postId = widget.snap['postId'] ?? ''; // Use 'postId' (lowercase)

    return Column(
      children: [
        // Header
        Container(
          color: mobileBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  widget.snap['profileImage'] ??
                      "https://plus.unsplash.com/premium_photo-1748209107745-cfbf79de23de?w=600&auto=format&fit=crop&q=60",
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            InkWell(
                              onTap: ()  async{
                                FirestoreMethod().deletePost(
                                  widget.snap['postId'] ?? '',
                                  widget.snap['postUrl'] ?? '',
                                );
                                Navigator.of(context).pop(); // Close the dialog

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: const Text(
                                  'delete',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
        // Post Image with Like Animation
        GestureDetector(
          onDoubleTap: () async {
            final firestoreMethod = FirestoreMethod();

            if (likes.contains(user.uid)) {
              // Unlike: remove uid from likes
              await firestoreMethod.unlikePost(user.uid, postId);
            } else {
              // Like: add uid to likes
              await firestoreMethod.likepost(user.uid, postId);
            }
            setState(() {
              islikeanimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    widget.snap['postUrl'] ??
                        "https://images.unsplash.com/photo-1557110437-0bcd0a636d62?w=600&auto=format&fit=crop&q=60",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Show big heart only during animation
              AnimatedOpacity(
                opacity: islikeanimating ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                onEnd: () {
                  setState(() {
                    islikeanimating = false;
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ],
          ),
        ),
        // Action Row
        Row(
          children: [
            Likeanimation(
              isAnimating: (likes.contains(user.uid)),
              duration: const Duration(milliseconds: 2000),
              child: IconButton(
                onPressed: () async {
                  final firestoreMethod = FirestoreMethod();
                  if (likes.contains(user.uid)) {
                    await firestoreMethod.unlikePost(user.uid, postId);
                  } else {
                    await firestoreMethod.likepost(user.uid, postId);
                  }
                  setState(() {});
                },
                icon: Icon(
                  likes.contains(user.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: likes.contains(user.uid)
                      ? Colors.red
                      : Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Comments(
                  snap: widget.snap, // Pass the snap data to Comments screen
                  
                ),));
              },
              icon: const Icon(Icons.comment_outlined, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_outlined, color: Colors.white),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        // Description and Likes
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
                child: Text('${likes.length} likes'),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: primaryColor),
                    children: [
                      TextSpan(
                        text: widget.snap['username'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " ${widget.snap['description'] ?? ''}",
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to comments screen
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.snap['datePublished'] != null
                        ? DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate())
                        : '',
                    style: const TextStyle(color: secondaryColor, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// FirestoreMethod class
class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> likepost(String uid, String postId) async {
    try {
      if (postId.isNotEmpty) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      } else {
        print('Error: postId is empty');
      }
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> unlikePost(String uid, String postId) async {
    try {
      if (postId.isNotEmpty) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        print('Error: postId is empty');
      }
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  Future<void> deletePost(String postId, String postUrl) async {
    try {
      if (postId.isNotEmpty) {
        await _firestore.collection('posts').doc(postId).delete();
        // Optionally, delete the image from storage if needed using postUrl
      } else {
        print('Error: postId is empty');
      }
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
