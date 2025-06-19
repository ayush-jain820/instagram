import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobilescreenlayout.dart';
import 'package:instagram/responsive/responsive_layoutscreen.dart';
import 'package:instagram/responsive/webscreenlayout.dart';
import 'package:instagram/screens/signupscreen.dart';
import 'package:instagram/utils.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/inputtextfield.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();

  bool isloading = false;

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

    super.dispose();
  }

  void loginuser() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethods().loginuser(
      email: _emailcontroller.text,
      passoword: _passwordcontroller.text,
    );
    if (res != "success") {
      showsnackbar(context, res);
      setState(() {
        isloading = false;
      });
    } else {
      Navigator.of(context).pushReplacement(
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

  void navigatetosignup() {
    print("Navigating to signup screen");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Signupscreen()),
    );
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

              // ignore: deprecated_member_use
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

              const SizedBox(height: 18),

              // login button
              InkWell(
                onTap: () {
                  loginuser();
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
                            "loginscreen",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                ),
              ),

              Flexible(flex: 2, child: Container()),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),

                    child: const Text("Don't have an account?"),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      navigatetosignup();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Signup",
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> Loginuser({
    required String email,
    required String passoword,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty || passoword.isNotEmpty) {
        // login user
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: passoword,
        );
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'user not found';
      } else if (e.code == 'wrong-password') {
        res = 'wrong password';
      } else if (e.code == 'invalid-email') {
        res = 'your email is invalid';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
