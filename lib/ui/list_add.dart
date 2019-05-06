///
///list_add.dart
///when click add will show this page
///
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddlistState();
  }
}

class AddlistState extends State {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("New Subject"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(padding: EdgeInsets.all(20.0), children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  labelText: "Subject",
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) => (value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text(
                  'Save',
                ),
                color: Theme.of(context).buttonColor,
                elevation: 4.0,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Firestore.instance.collection('todo').add({
                      'title': _title.text,
                      'done': 0,
                    }).then((value) {
                      Navigator.pop(context, '/home');
                    });
                  }
                },
              )
            ]),
          ),
        ));
  }
}
