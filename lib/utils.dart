import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource Source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? _file = await _picker.pickImage(source: Source);
  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    // ignore: avoid_print
    print("No image selected");
  }
}

showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content), duration: const Duration(seconds: 2)),
  );
}
