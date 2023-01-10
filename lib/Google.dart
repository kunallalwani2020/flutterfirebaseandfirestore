import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:flutterfirebase/posts/posts_screen.dart';
import 'package:flutterfirebase/utils/utile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google extends StatefulWidget {
  const Google({Key? key}) : super(key: key);

  @override
  _GoogleState createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  // googleLogin() async {
  //   // print("googleLogin method Called");
  // }

  // Future<void> logout() async {
  //   await GoogleSignIn().disconnect();
  //   FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: roundButton(
          title: 'Google',
          onTap: () async {
            GoogleSignIn _googleSignIn = GoogleSignIn();
            try {
              var reslut = await _googleSignIn.signIn();
              if (reslut == null) {
                return;
              }

              final userData = await reslut.authentication;
              final credential = GoogleAuthProvider.credential(
                  accessToken: userData.accessToken, idToken: userData.idToken);
              var finalResult =
                  await FirebaseAuth.instance.signInWithCredential(credential);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostsScreen(),
                  ));
              Util().toastMessage(reslut.displayName.toString());

              print("Result $reslut");
              print(reslut.displayName);
              print(reslut.email);
              print(reslut.photoUrl);
            } catch (error) {
              print(error);
            }
          }),
    ));
  }
}
