import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    File? image,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    // Try to login to signup...
    try {
      //Sign in
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      //SignUp
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // upload profile photo to Firebase Storage before adding a user

        // create 'usesr_images' folder on Firebase Storage if null
        final imageRef = _storage
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');

        // upload image with userid as image name
        imageRef.putFile(image!).whenComplete(() async {
          // create pfp image url from Firebase
          final url = await imageRef.getDownloadURL();

          // get Firebase Cloud Messaging Token
          final fcmToken = await FirebaseMessaging.instance.getToken();

          // create a 'users' collection in Cloud Firestore collections.
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'imageUrl': url,
            'fcmtoken': fcmToken,
          });
        });
      }
    } on FirebaseAuthException catch (err) {
      String message = 'An error occured, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // ignore: prefer_const_constructors
      body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
