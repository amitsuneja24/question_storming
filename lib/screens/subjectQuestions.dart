import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Flutter_Apps/question_storming/lib/screens/Answers.dart';

class SubjectDetails extends StatefulWidget {
  FirebaseUser user;
  int index;
  String name;

  SubjectDetails({this.user, this.index, this.name});

  @override
  _SubjectDetailsState createState() =>
      _SubjectDetailsState(user: user, index: index, name: name);
}

class _SubjectDetailsState extends State<SubjectDetails> {
  FirebaseUser user;
  int index;
  String name;
  TextEditingController subjectDetailController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  _SubjectDetailsState({this.user, this.index, this.name});

  var firestoreDb = Firestore.instance.collection('subject');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            _ShowFormInDialog(context);
          },
          elevation: 20,
        ),
      ),
      appBar: AppBar(
        title: Text("$name"),
      ),
      body: StreamBuilder(
        stream: firestoreDb.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List questionList =
              snapshot.data.documents[index].data['Questions']?.keys?.toList();
          List answerList = snapshot
              .data.documents[index].data['Questions']?.values
              ?.toList();

          //[index][0]?.values.toList()
//          List questionAnswerList=snapshot.data.documents[index].data['Questions'];
          int itemCount =
              snapshot.data.documents[index].data['Questions']?.length ?? 0;
          return (itemCount == 0)
              ? Center(
                  child: Text(
                  "No Questions Yet",
                  style: TextStyle(fontSize: 30),
                ))
              : ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, int index) {
                    return Container(
                      //padding: EdgeInsets.symmetric(horizontal: 7),
                      //height: 200,

                      child: Card(
                          color: Colors.white,
                          child: ClipRRect(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("${questionAnswerList[index].keys.toList()[0]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                              (questionAnswerList[index].values.toList()[0].length!=0)?Container(padding:EdgeInsets.only(top: 5),child: Text("${questionAnswerList[index].values.toList()[0][0]}")):Container(width: 0,height: 0,),
//
//                            ],

                                children: <Widget>[
                                  Text(
                                    "${questionList[index]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  (answerList[index].length != 0)
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                    "${answerList[index][0].values.toList()[0]}")),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(
                                                    "- ${answerList[index][0].keys.toList()[0]}"),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text("Add Answer"),
                                        color: Colors.teal,
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Answers(
                                                      firebasedb: firestoreDb,
                                                      name: name,
                                                      topIndex: index,
                                                      baseindex: this.index)));
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    );
                  });
        },
      ),
    );
  }

  _ShowFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) => AlertDialog(
              actions: <Widget>[
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    if (subjectDetailController.text != null)
                      await firestoreDb.document(name).setData({
                        'Questions': {'${subjectDetailController.text}': []}
                      }, merge: true);
//                  await  firestoreDb.document(name).setData({'Questions':[{'${subjectDetailController.text}':[]}]},merge:true);
                    subjectDetailController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("cancel"),
                  onPressed: () {
                    subjectDetailController.clear();
                    Navigator.of(context).pop();
                  },
                )
              ],
              title: Text("Add Question"),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: subjectDetailController,
                      decoration: InputDecoration(
                        labelText: "Question",
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
