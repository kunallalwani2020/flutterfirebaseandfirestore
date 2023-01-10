import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterfirebase/Login.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutterfirebase/posts/posts_screen.dart';
import 'package:flutterfirebase/utils/utile.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key}) : super(key: key);

  @override
  _AddPostsState createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  bool loading = false;
  TextEditingController postController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(
              height: 38,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "What is in your mind?",
                  border: OutlineInputBorder(),
                  hintMaxLines: 4),
            ),
            SizedBox(
              height: 38,
            ),
            roundButton(
              title: "Add",
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                //  database.child('1').set(
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                database.child(id).set({
                  'title': postController.text.toString(),
                  'id': id,
                }).then((value) {
                  Util().toastMessage("Post added");
                  setState(() {
                    loading = false;
                  });
                  postController.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostsScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Util().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
