///
///home.dart
///main page, first page when go to thiss app.
///
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './list_add.dart';

class Todolist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TodolistState();
  }
}

class TodolistState extends State {
  int _index = 0;

  //AppBar and bottomNavigationBar
  @override
  Widget build(BuildContext context) {
    // page list element
    final List<Widget> _children = [Task(), Completed()];

    return Scaffold(
      body: Center(child: _children[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Task')),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed"))
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }

  Widget Completed() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Todo"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                Firestore.instance
                    .collection('todo')
                    .where("done", isEqualTo: 1)
                    .getDocuments()
                    .then((value) {
                  value.documents.forEach((item) {
                    item.reference.delete();
                  });
                });
              }),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .where('done', isEqualTo: 1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot.data.documents);
            } else {
              return Text("loading...");
            }
          },
        ),
      ),
    );
  }

  Widget buildList(List<DocumentSnapshot> data) {
    return data.length != 0
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: new BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5))),
                child: CheckboxListTile(
                  title: Text(data.elementAt(index).data["title"]),
                  onChanged: (bool value) {
                    setState(() {
                      Firestore.instance
                          .collection('todo')
                          .document(data.elementAt(index).documentID)
                          .setData({
                        'title': data.elementAt(index).data['title'],
                        'done': 0
                      });
                    });
                  },
                  value: data.elementAt(index).data['done'] == 1,
                ),
              );
            })
        : Center(
            child: Text("No data found...", style: TextStyle(fontSize: 15)));
  }

  Widget Task() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Todo"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Addlist()));
                });
              }),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .where('done', isEqualTo: 0)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return buildList1(snapshot.data.documents);
            } else {
              return Text("loading...");
            }
          },
        ),
      ),
    );
  }

  Widget buildList1(List<DocumentSnapshot> data) {
    return data.length != 0
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: new BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5))),
                child: CheckboxListTile(
                  title: Text(data.elementAt(index).data["title"]),
                  onChanged: (bool value) {
                    setState(() {
                      Firestore.instance
                          .collection('todo')
                          .document(data.elementAt(index).documentID)
                          .setData({
                        'title': data.elementAt(index).data['title'],
                        'done': 1
                      });
                    });
                  },
                  value: data.elementAt(index).data['done'] != 0,
                ),
              );
            },
          )
        : Center(
            child: Text("No data found...", style: TextStyle(fontSize: 15)));
  }
}
