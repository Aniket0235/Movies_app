import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';

// ignore: must_be_immutable
class AddMovies extends StatefulWidget {
  static const routeName = '/user-addMovie';

  @override
  _AddMoviesState createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  void dispose() {
    _nameFocusNode.dispose();
    _directorFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  final CollectionReference ref =
      FirebaseFirestore.instance.collection('new movies');
  final TextEditingController name = TextEditingController();
  final TextEditingController director = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _directorFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate() {
    if (formkey.currentState!.validate()) {
      print("validated");
    } else {
      print("Not validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Movie'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                validate();
                ref.doc(name.text).set({
                  'name': name.text,
                  'director': director.text,
                  'imageUrl': imageUrl.text,
                })
                  ..whenComplete(() => Navigator.pop(context));
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: formkey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildMovieName(),
                SizedBox(height: 20),
                buildDirectorName(),
                SizedBox(height: 20),
                buildImageUrl(),
                SizedBox(height: 20),
                buildDone(),
              ]))),
    );
  }

  Widget buildMovieName() => TextFormField(
      controller: name,
      decoration: InputDecoration(
        labelText: 'name of movie',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter name of movie";
        }
        return null;
      });

  Widget buildDirectorName() => TextFormField(
      controller: director,
      decoration: InputDecoration(
        labelText: 'director',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _directorFocusNode,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_directorFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter name of director';
        }
        return null;
      });

  Widget buildImageUrl() =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top: 8, right: 10),
            decoration: BoxDecoration(
                border: Border.all(width: 1), color: Colors.white10),
            child: imageUrl.text.isEmpty
                ? Center(child: Text('image preview'))
                : FittedBox(
                    child: Image.network(
                      imageUrl.text,
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Expanded(
            child: TextFormField(
          focusNode: _imageUrlFocusNode,
          controller: imageUrl,
          decoration: InputDecoration(
              labelText: 'imageUrl',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_imageUrlFocusNode);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter an Image URL.';
            }
            if (!value.startsWith('http') && !value.startsWith('https')) {
              return 'Please enter a valid URL.';
            }
            if (!value.endsWith('.png') &&
                !value.endsWith('.jpg') &&
                !value.endsWith('.jpeg')) {
              return 'Please enter a valid URL.';
            }
            return null;
          },
        ))
      ]);

  Widget buildDone() => Builder(
      builder: (context) => MaterialButton(
          minWidth: double.infinity,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          height: 50,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            validate();
            ref.doc(name.text).set({
              'name': name.text,
              'director': director.text,
              'imageUrl': imageUrl.text,
            })
              ..whenComplete(() => Navigator.pushReplacementNamed(
                  context, MyHomePage.routeName));
          },
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )));
}
