import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfirebase/Google.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:flutterfirebase/Signup.dart';
import 'package:flutterfirebase/firebaseServices/splash_Services.dart';
import 'package:flutterfirebase/firestore/postScreenfirestore.dart';
import 'package:flutterfirebase/login_with_phonenumber.dart';
import 'package:flutterfirebase/posts/posts_screen.dart';
import 'package:flutterfirebase/utils/utile.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'facebook.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  final FormField = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: email.text, password: password.text.toString())
        .then((value) {
      Util().toastMessage(value.user!.email.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostsScreen(),
          ));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Util().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

//  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text("Login")),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: FormField,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                                // /helperText: 'enter the email',
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email_rounded)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter the email';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                                //  helperText: 'enter the password',
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock_open)),
                            // keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter the password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                roundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (FormField.currentState!.validate()) {}
                    login();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signup(),
                              ));
                        },
                        child: Text("Signup"))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginWithPhonenumber(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login with phone number    "),
                          Icon(Icons.phone_android_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Google(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login with Google    "),
                          Icon(Icons.g_mobiledata_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Facebook(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login with Facebook    "),
                          Icon(Icons.facebook_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreenfirestore(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("FireStore Database "),
                          Icon(Icons.fireplace_sharp)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class roundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const roundButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: loading
                  ? CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    )
                  : Text(
                      title,
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
