import "dart:io";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutterfirebase/Login.dart';
import 'package:flutterfirebase/utils/utile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class Addpostthroughfirestore extends StatefulWidget {
  const Addpostthroughfirestore({Key? key}) : super(key: key);

  @override
  _AddpostthroughfirestoreState createState() =>
      _AddpostthroughfirestoreState();
}

class _AddpostthroughfirestoreState extends State<Addpostthroughfirestore> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final firestorePostController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Post');
  final storage = FirebaseStorage.instance;
  //final databaseRef = FirebaseFirestore.instance.collection('Post');
// image initalization//
  File? _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: firestorePostController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What is in your mind?",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  //shown image
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Icon(
                          Icons.image_outlined,
                          size: 50,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              roundButton(
                  title: 'Add Post',
                  loading: loading,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      String id =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      //imagesUploadCode sepeate componnets
                      //                    Reference ref = FirebaseStorage.instance
                      //     .ref('/PostImage/' + DateTime.now().millisecondsSinceEpoch.toString());

                      // UploadTask uploadTask = ref.putFile(_image!.absolute);
                      // Future.value(uploadTask).then((value) async {
                      //   var newUrl = await ref.getDownloadURL();
                      //   String id = DateTime.now().millisecondsSinceEpoch.toString();
                      //  final images=
                      //   firestore
                      //       .doc(id)
                      //       .set({'id': id, 'imageUrl': newUrl.toString()}).then((value) {
                      //     Util().toastMessage('uploaded');
                      //   }).onError((error, stackTrace) {
                      //     print(error.toString());
                      //   });
                      // }).onError((error, stackTrace) {
                      //   Util().toastMessage(error.toString());
                      // });
                      Reference ref = FirebaseStorage.instance.ref(
                          '/PostImage/' +
                              DateTime.now().millisecondsSinceEpoch.toString());

                      UploadTask uploadTask = ref.putFile(_image!.absolute);
                      Future.value(uploadTask).then((value) async {
                        var newUrl = await ref.getDownloadURL();

                        firestore.doc(id).set({
                          'title': firestorePostController.text.toString(),
                          "id": id,
                          'imageUrl': newUrl.toString()
                        }).then((value) {
                          Util().toastMessage("Post Added");
                          setState(() {
                            loading = false;
                          });
                          firestorePostController.clear();
                        }).onError((error, stackTrace) {
                          Util().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> Images(String img) async {}
