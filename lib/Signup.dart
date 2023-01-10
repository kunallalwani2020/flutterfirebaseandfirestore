import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfirebase/utils/utile.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool loading = false;
  final FormField = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("Signup"),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter the email";
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
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_open)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter the password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              )),
          roundButton(
            title: 'Signup',
            loading: loading,
            onTap: () {
              if (FormField.currentState!.validate()) {
                //   auth.createUserWithEmailAndPassword(
                //       email: email.text.toString(),
                //       password: password.text.toString());
                setState(() {
                  loading = true;
                });
                _auth
                    .createUserWithEmailAndPassword(
                        email: email.text.toString(),
                        password: password.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Util().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text("Login"))
            ],
          )
        ],
      )),
    );
  }
}
