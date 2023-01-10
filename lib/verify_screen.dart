import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/posts/posts_screen.dart';
import 'package:flutterfirebase/utils/utile.dart';

import 'login.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationId;
  const VerifyScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool loading = false;
  TextEditingController verifyController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            TextFormField(
              controller: verifyController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: "6-digit number "),
            ),
            SizedBox(
              height: 20,
            ),
            roundButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  var credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyController.text.toString());
                  try {
                    await _auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostsScreen(),
                        ));
                  } catch (e) {
                    setState(() {
                      loading = true;
                    });
                    Util().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
