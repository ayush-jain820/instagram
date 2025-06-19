import 'package:flutter/material.dart';

class Webscreenlayout extends StatelessWidget {
  const Webscreenlayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Web Screen Layout',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
