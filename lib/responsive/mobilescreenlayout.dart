import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/feed_screen.dart';
import 'package:instagram/models/user.dart' as my_user;
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/screens/addpost_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

class Mobilescreenlayout extends StatefulWidget {
  const Mobilescreenlayout({super.key});

  @override
  State<Mobilescreenlayout> createState() => _MobilescreenlayoutState();
}

class _MobilescreenlayoutState extends State<Mobilescreenlayout> {
  String username = "";
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    getUsername();
    pageController = PageController();
  }

  void getUsername() async {
    // Simulate a network call to fetch the username

    DocumentSnapshot snap =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
   
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'] as String;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  void pagechanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    my_user.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: pagechanged,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Center(child: FeedScreen()),
          Center(child: SearchScreen()),
          Center(child: AddpostScreen()),
          Center(child: Text("Notifications Page")),
          Center(child: ProfileScreen( uid: FirebaseAuth.instance.currentUser!.uid,)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationtapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: "add post",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: "notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: "notifications",
          ),
        ],
      ),
    );
  }
}
