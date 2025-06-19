import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart' as my_user;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<my_user.User> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently logged in");
    }

    DocumentSnapshot docSnap =
        await _firestore.collection('users').doc(user.uid).get();

    if (!docSnap.exists) {
      throw Exception("User document does not exist");
    }

    return my_user.User.fromSnap(docSnap);
  }

  Future<String> signup({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        print("Signup method called");
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        my_user.User user = my_user.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: "",

          followers: [],
          following: [],
        );
        try {
          print("Uploading user data: ${user.toJson()}");
          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
          print("User document created!");
        } catch (e) {
          print("Firestore write error: $e");
        }

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        res = 'your password is too weak';
      } else if (err.code == 'email-already-in-use') {
        res = 'email is already in use';
      } else if (err.code == 'invalid-email') {
        res = 'your email is invalid';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginuser({
    required String email,
    required String passoword,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty && passoword.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: passoword,
        );
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
   Future<void> signOut()async{
      await FirebaseAuth.instance.signOut();
    }
}
