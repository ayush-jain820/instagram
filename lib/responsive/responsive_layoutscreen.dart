import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provider.dart';
//import 'package:flutter/rendering.dart';
import 'package:instagram/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutscreen extends StatefulWidget {
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
  const ResponsiveLayoutscreen({
    super.key,
    required this.webscreenlayout,
    required this.mobilescreenlayout,
  });

  @override
  State<ResponsiveLayoutscreen> createState() => _ResponsiveLayoutscreenState();
}

class _ResponsiveLayoutscreenState extends State<ResponsiveLayoutscreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, Constraints) {
        if (Constraints.maxWidth > webscreensize) {
          // web screen
          return widget.webscreenlayout;
        } else {
          // mobile screen
          return widget.mobilescreenlayout;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    adddata();
  }

  void adddata() async {
    UserProvider _userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    await _userProvider.refreshUser();
  }
}
