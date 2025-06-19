import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/resources/firestore_method.dart';
import 'package:instagram/utils.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

class AddpostScreen extends StatefulWidget {
  const AddpostScreen({super.key});

  @override
  State<AddpostScreen> createState() => _AddpostScreenState();
}

class _AddpostScreenState extends State<AddpostScreen> {
  Uint8List? _file;
  bool isloading = false;
  final TextEditingController _captionController = TextEditingController();
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (contet) {
        return SimpleDialog(
          title: const Text("create a post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                // Logic to take a photo
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("choose from gallery"),
              onPressed: () async {
                // Logic to take a photo
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
      isloading = false;
      _captionController.clear();
    });
  }

  Future<void> postImage(String uid, String username) async {
    try {
      setState(() {
        isloading = true;
      });
      await FirestoreMethod().uploadPost(
        _captionController.text,
        uid,
        username,
      );
      setState(() {
        isloading = false;
        _file = null; // Reset the file after posting
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: LinearProgressIndicator(
            color: Colors.blueAccent,
            backgroundColor: Colors.white,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
     
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
          child: IconButton(
            onPressed: () {
              _selectImage(context);
            },
            icon: Icon(Icons.add_a_photo, color: Colors.white, size: 30),
          ),
        )
        : Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                clearImage();
              },
            ),
            title: const Text('to Post'),
            actions: [
              TextButton(
                onPressed: () async {
                  await postImage(user.uid, user.username);
                  setState(() {
                    _captionController.clear();
                    _file = null;
                  });
                },

                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl ??
                          'https://example.com/default_profile_image.png', // Fallback URL
                    ),
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _captionController,
                      decoration: InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: MemoryImage(_file!)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
