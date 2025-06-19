import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(hintText: "search for a user"),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUser = true;
            });
          },
          controller: searchController,
        ),
      ),
      body:
          isShowUser
              ? FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection("users")
                        .where(
                          "username",
                          isGreaterThanOrEqualTo: searchController.text,
                        )
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final userData =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userData['photoUrl'] ??
                                "https://plus.unsplash.com/premium_photo-1748960861503-99b1f5412a81?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxfHx8ZW58MHx8fHx8",
                          ),
                        ),
                        title: Text(userData['username'] ?? 'No Username'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]["uid"],)));
                          // You can navigate to the user's profile here
                        },
                      );
                    },
                  );
                },
              )
              : const Center(child: Text("Search for users")),
    );
  }
}
