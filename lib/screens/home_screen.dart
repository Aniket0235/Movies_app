import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/add_movies.dart';
import 'package:movies_app/helpers/auth.dart';
import 'package:movies_app/helpers/helpersfunctions.dart';
import 'package:movies_app/widget/authenticate.dart';

class MyHomePage extends StatelessWidget {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('new movies');
  final TextEditingController name = TextEditingController();
  final TextEditingController director = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();

  deleteMovie(String name) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('new movies').doc(name);
    return documentReference.delete();
  }

  static const routeName = '/user-homePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'My Movies',
          ),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AddMovies.routeName);
                },
                icon: Icon(Icons.add_circle)),
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: GestureDetector(
                              onTap: () async {
                                await AuthMethods().signOut().then((value) =>
                                    HelperFunctions.saveUserLoggedIn(
                                        value != null ? true : false));
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Authenticate(),
                                ));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "LogOut",
                                    ),
                                  ],
                                ),
                              )),
                          value: 0)
                    ]),
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.requireData;
              return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (_, index) {
                    return Card(
                        child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.blue[100],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              leading: CircleAvatar(
                                  radius: 36,
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]['imageUrl'])),
                              title: Text(
                                snapshot.data!.docs[index]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle:
                                  Text(snapshot.data!.docs[index]['director']),
                              trailing: GestureDetector(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  deleteMovie(
                                      snapshot.data!.docs[index]['name']);
                                },
                              ),
                            )));
                  });
            } else {
              return Center(child: Text("Loading"));
            }
          }),
    );
  }
}
