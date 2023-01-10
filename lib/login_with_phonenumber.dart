import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutterfirebase/utils/utile.dart';
import 'package:flutterfirebase/verify_screen.dart';

class LoginWithPhonenumber extends StatefulWidget {
  const LoginWithPhonenumber({Key? key}) : super(key: key);

  @override
  _LoginWithPhonenumberState createState() => _LoginWithPhonenumberState();
}

class _LoginWithPhonenumberState extends State<LoginWithPhonenumber> {
  bool loading = false;
  TextEditingController phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: "Enter mobile number "),
            ),
            SizedBox(
              height: 20,
            ),
            roundButton(
                title: 'Send Code',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (PhoneAuthCredential credential) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        setState(() {
                          loading = false;
                        });
                        Util().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => VerifyScreen(
                                      verificationId: verificationId,
                                    ))));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        setState(() {
                          loading = false;
                        });
                        Util().toastMessage(e.toString());
                      });
                }),
          ],
        ),
      ),
    );
  }
}
