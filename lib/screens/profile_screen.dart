import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/loginscreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int postlen = 0;
  Map<String, dynamic> userdata = {};
  int followers = 0;
  int following = 0;
  bool isfollowing = false;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    try {
      var postsnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();

      var snap =
          await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();

      if (!snap.exists) {
        throw Exception("User not found.");
      }

      userdata = snap.data() ?? {};

      List followersList = userdata["followers"] ?? [];
      List followingList = userdata["following"] ?? [];

      followers = followersList.length;
      following = followingList.length;
      postlen = postsnap.docs.length;
      isfollowing = followersList.contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userdata.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userdata['username']?.toString() ?? ''),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      child: ClipOval(
                        child: Image(
                          image: NetworkImage(
                              "https://plus.unsplash.com/premium_photo-1748960861503-99b1f5412a81?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxfHx8ZW58MHx8fHx8"),
                          fit: BoxFit.cover,
                          width: 72,
                          height: 72,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildstatcolumn(postlen, "posts"),
                              buildstatcolumn(followers, "followers"),
                              buildstatcolumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid
                                  ? FollowButton(
                                      backgroundColor: mobileBackgroundColor,
                                      borderColors: Colors.grey,
                                      text: "Signout",
                                      textColor: primaryColor,
                                      function: () async {
                                        await AuthMethods().signOut();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => Loginscreen()),
                                        );
                                      },
                                    )
                                  : isfollowing
                                      ? FollowButton(
                                          backgroundColor: Colors.white,
                                          borderColors: Colors.grey,
                                          text: "Unfollow",
                                          textColor: Colors.black,
                                          function: () async {
                                            await FirestoreMethodss().followuser(
                                              FirebaseAuth.instance.currentUser!.uid,
                                              widget.uid,
                                              context: context,
                                            );
                                            setState(() {
                                              isfollowing = false;
                                              followers--;
                                            });
                                          },
                                        )
                                      : FollowButton(
                                          backgroundColor: mobileBackgroundColor,
                                          borderColors: Colors.blue,
                                          text: "Follow",
                                          textColor: primaryColor,
                                          function: () async {
                                            await FirestoreMethodss().followuser(
                                              FirebaseAuth.instance.currentUser!.uid,
                                              widget.uid,
                                              context: context,
                                            );
                                            setState(() {
                                              isfollowing = true;
                                              followers++;
                                            });
                                          },
                                        ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userdata["username"]?.toString() ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userdata["bio"]?.toString() ?? '',
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildstatcolumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class FirestoreMethodss {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followuser(String uid, String followid,
      {required BuildContext context}) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as Map<String, dynamic>)["following"] ?? [];

      if (following.contains(followid)) {
        await _firestore
            .collection("users")
            .doc(followid)
            .update({"followers": FieldValue.arrayRemove([uid])});
        await _firestore
            .collection("users")
            .doc(uid)
            .update({"following": FieldValue.arrayRemove([followid])});
      } else {
        await _firestore
            .collection("users")
            .doc(followid)
            .update({"followers": FieldValue.arrayUnion([uid])});
        await _firestore
            .collection("users")
            .doc(uid)
            .update({"following": FieldValue.arrayUnion([followid])});
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
