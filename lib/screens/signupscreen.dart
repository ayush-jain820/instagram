import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobilescreenlayout.dart';
import 'package:instagram/responsive/responsive_layoutscreen.dart';
import 'package:instagram/responsive/webscreenlayout.dart';
import 'package:instagram/screens/loginscreen.dart';
import 'package:instagram/utils.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/inputtextfield.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  Uint8List? _image;
  bool isloading = false;

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
    _biocontroller.dispose();
    super.dispose();
  }

  Future<void> selectimage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupuser() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethods().signup(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
      username: _usernamecontroller.text,
      bio: _biocontroller.text,
      file: _image,
    );
    setState(() {
      isloading = false;
    });
    if (res != "success") {
      showsnackbar(context, res);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => const ResponsiveLayoutscreen(
                webscreenlayout: Webscreenlayout(),
                mobilescreenlayout: Mobilescreenlayout(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage:
                        _image != null
                            ? MemoryImage(_image!)
                            : const NetworkImage(
                              "https://images.unsplash.com/photo-1557110437-0bcd0a636d62?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8ZGVmYXVsdCUyMHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8fDB8fHww",
                            ),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectimage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              // ignore: deprecated_member_use
              SvgPicture.asset(
                'lib/assets/ic_instagram.svg',
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
                height: 64,
              ),
              SizedBox(height: 16),

              Inputtextfield(
                texteditingcontroller: _usernamecontroller,
                hinttext: "enter your username",
                inputtextfield: TextInputType.text,
              ),
              const SizedBox(height: 18),
              Inputtextfield(
                texteditingcontroller: _emailcontroller,
                hinttext: "enter your email",
                inputtextfield: TextInputType.emailAddress,
              ),

              // email textfield
              // password textfield
              SizedBox(height: 18),
              Inputtextfield(
                texteditingcontroller: _passwordcontroller,
                hinttext: "enter your password",
                inputtextfield: TextInputType.text,
                istrue: true,
              ),
              const SizedBox(height: 18),
              Inputtextfield(
                texteditingcontroller: _biocontroller,
                hinttext: "enter your bio",
                inputtextfield: TextInputType.text,
              ),

              const SizedBox(height: 18),

              // login button
              InkWell(
                onTap: () {
                  signupuser();
                },

                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),

                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: blueColor,
                  ),
                  child:
                      isloading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 14),
              Flexible(flex: 2, child: Container()),
              Row(
                children: [
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),

                      child: const Text("already have an account?"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginscreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              // transitioning to signup
            ],
          ),
        ),
      ),
    );
  }
}
