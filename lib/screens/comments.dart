import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';

import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens/comment_card.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Comments extends StatefulWidget {
  final  snap;
  const Comments({super.key, required this.snap});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final TextEditingController _commentController = TextEditingController();

    return Scaffold(
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished',descending: true).snapshots(), builder: 
      (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No comments yet"));
        }
        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
           
            return CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            );
          },
        );
      }),
      appBar: AppBar(
        title: const Text("comments"),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.only(left: 10, right: 8),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  "https://plus.unsplash.com/premium_photo-1748209107745-cfbf79de23de?w=600&auto=format&fit=crop&q=60",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "write a comment as ${user.username}",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                 await FirestoreMethods().postComment(
                    widget.snap['postId'], // Use the correct postId
                    _commentController.text,
                    user.uid,
                    user.username,
                  );
                  setState(() {
                    _commentController.text="";
                  });

                  
                  _commentController.clear(); // Clear the input field after posting
                 
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postComment(String postId, String text, String uid, String name) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1(); // Generate a unique comment ID
        await _firestore.collection("posts").doc(postId).collection("comments").doc(commentId).set({
          "text": text,
          "uid": uid,
          "username": name,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Comment text is empty");
      }
    } catch (err) {
      print("Error posting comment: ${err.toString()}");
    }
  }
}