import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/firestore/addpostthroughfirestore.dart';
import 'package:flutterfirebase/utils/utile.dart';

class PostScreenfirestore extends StatefulWidget {
  const PostScreenfirestore({Key? key}) : super(key: key);

  @override
  _PostScreenfirestoreState createState() => _PostScreenfirestoreState();
}

class _PostScreenfirestoreState extends State<PostScreenfirestore> {
  final firestore = FirebaseFirestore.instance.collection('Post').snapshots();
  final ref1 = FirebaseFirestore.instance.collection('Post');
  final updateText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Firestore Post"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: Container(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: firestore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();
                    if (snapshot.hasError) return Text("has error");

                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var field = "title";
                        final title =
                            snapshot.data!.docs[index][field].toString();
                        return Container(
                          child: Card(
                            child: ListTile(
                              title: Text(snapshot.data!.docs[index]["title"]
                                  .toString()),
                              // leading: Image.network(
                              //     snapshot.data!.docs[index]["imageUrl"].toString()),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialogBox1(
                                              title,
                                              snapshot.data!.docs[index]["id"]
                                                  .toString());
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text("Edit"),
                                      )),
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          ref1
                                              .doc(snapshot
                                                  .data!.docs[index]["id"]
                                                  .toString())
                                              .delete();
                                        },
                                        leading: Icon(Icons.delete),
                                        title: Text("Delete"),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ));
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addpostthroughfirestore(),
                ));
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> showDialogBox1(String title, String id) async {
    updateText.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: updateText,
                decoration: InputDecoration(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // ignore: prefer_typing_uninitialized_variables

                    ref1.doc(id).update(
                        {'title': updateText.text.toString()}).then((value) {
                      Util().toastMessage("Post Update");
                    }).onError((error, stackTrace) {
                      Util().toastMessage(error.toString());
                    });
                  },
                  child: Text("Update"))
            ],
          );
        });
  }
}
