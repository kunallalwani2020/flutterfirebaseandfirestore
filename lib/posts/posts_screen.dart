import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/Login.dart';
import 'package:flutterfirebase/database/add_posts.dart';
import 'package:flutterfirebase/utils/utile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('post');
  final searchfilter = TextEditingController();
  final updateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          //automaticallyImplyLeading: false,
          title: Text("Post"),
          actions: [
            IconButton(
                onPressed: () async {
                  _auth.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      )).onError((error, stackTrace) {
                    Util().toastMessage(error.toString());
                  });
                  await GoogleSignIn().disconnect();
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout_outlined)),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchfilter,
                decoration: InputDecoration(
                  hintText: "Seatch",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            //  two method database data initalized
            // Expanded(
            //     child: StreamBuilder(
            //   stream: ref.onValue,
            //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //     ;
            //     if (!snapshot.hasData) {
            //       return CircularProgressIndicator();
            //     } else {
            //       Map<dynamic, dynamic> map =
            //           snapshot.data!.snapshot.value as dynamic;
            //       List<dynamic> list = [];
            //       list.clear();
            //       list = map.values.toList();
            //       return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title: Text(list[index]['title']),
            //           );
            //         },
            //       );
            //     }
            //   },
            // )),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey[200],
                  child: FirebaseAnimatedList(
                    defaultChild: Text(
                      "Loading",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    query: ref,
                    itemBuilder: (context, snapshot, animation, index) {
                      // searching system
                      final title = snapshot.child('title').value.toString();
                      if (searchfilter.text.isEmpty) {
                        return Container(
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.child('title').value.toString(),
                                textAlign: TextAlign.center,
                              ),
                              trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                showMyDialog(
                                                    title,
                                                    snapshot
                                                        .child("id")
                                                        .value
                                                        .toString());
                                              },
                                              leading: Icon(Icons.edit),
                                              title: Text("Edit"),
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                ref
                                                    .child(snapshot
                                                        .child('id')
                                                        .value
                                                        .toString())
                                                    .remove();
                                              },
                                              leading: Icon(Icons.delete),
                                              title: Text("delete"),
                                            ))
                                      ]),
                            ),
                          ),
                        );
                      } else if (title.toLowerCase().contains(
                          searchfilter.text.toLowerCase().toLowerCase())) {
                        return Container(
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.child('title').value.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }

                      // return Container(
                      //   child: Card(
                      //     child: ListTile(
                      //       title: Text(
                      //         snapshot.child('title').value.toString(),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                  )),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPosts(),
                ));
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> showMyDialog(String title, String id) async {
    updateController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: updateController,
                decoration: InputDecoration(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    'title': updateController.text.toLowerCase()
                  }).then((value) {
                    Util().toastMessage("Post Updated");
                  }).onError((error, stackTrace) {
                    Util().toastMessage(error.toString());
                  });
                },
                child: Text("Update"),
              )
            ],
          );
        });
  }
}
