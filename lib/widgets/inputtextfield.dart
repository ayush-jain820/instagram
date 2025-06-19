import 'package:flutter/material.dart';

class Inputtextfield extends StatelessWidget {
  final TextEditingController texteditingcontroller;
  final bool istrue;
  final String hinttext;
  final TextInputType inputtextfield;
  const Inputtextfield({
    Key? key,
    required this.texteditingcontroller,
    this.istrue = false,
    required this.hinttext,
    required this.inputtextfield,
  });

  @override
  Widget build(BuildContext context) {
    final inputborder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );
    return TextField(
      controller: texteditingcontroller,
      decoration: InputDecoration(
        hintText: hinttext,
        border: inputborder,
        focusedBorder: inputborder,
        filled: true,
      ),
      keyboardType: inputtextfield,
      obscureText: istrue,
    );
  }
}
