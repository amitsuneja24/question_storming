import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:questionstorming/screens/subjectQuestions.dart';
class Home extends StatefulWidget {
  final FirebaseUser user;

//DocumentSnapshot dsc;

  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(user: user);
}

class _HomeState extends State<Home> {

  final FirebaseUser user;

  _HomeState({this.user});

  var firedb = Firestore.instance.collection("subject").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          child: Icon(Icons.add,size: 30,),
          onPressed: (){
            _ShowFormInDialog(context);
          },
          elevation: 20,

        ),
      ),
      appBar: AppBar(
        title: Text("Subjects"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: firedb,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return GridView.builder(
              primary: false,
              padding: EdgeInsets.all(7),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,childAspectRatio: 1.5,crossAxisSpacing: 4,mainAxisSpacing: 4),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, int index) {
                return Container(
                  decoration: BoxDecoration(

                  ),
                  child: InkWell(
                    splashColor: Colors.teal,
                    onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubjectDetails(user: user,index: index,name:snapshot.data.documents[index]
                         .documentID)));
                    },
                    child: Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 15,
                      child: Center(child: Text(
                        "${snapshot.data.documents[index]
                            .documentID}", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold),)),
                    ),
                  ),
                );
              },
            );
//    return
          }
      ),
    );
  }


//        child: Column(
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.only(top:10),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Card(
//                        child: Container(
//                          width: MediaQuery.of(context).size.width/2.1,
//                          height: 100,
//                          color: Colors.pink,
//                          child: Center(child: Text("Arts",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
//                        ),
//                      ),
//
//
//                    ],
//                  ),
//                )
//              ],
//            ),
//)

//,


//);


Widget CustomCard(String subject) {
  return Card(
    child: Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 2.1,
      height: 100,
      color: Colors.pink,
      child: Center(child: Text("$subject",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
    ),);
}
  TextEditingController subjectController = TextEditingController();
  _ShowFormInDialog(BuildContext context) {
    return showDialog(
        context: context, barrierDismissible: true, builder: (param) =>
        AlertDialog(
          actions: <Widget>[
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                if(subjectController.text!=null)
                await  Firestore.instance.collection("subject").document(subjectController.text).setData({});
                subjectController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
                subjectController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
          title: Text("Add Category"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                      labelText: "Category Name",
                  ),
                ),
              ],
            ),
          ),
        ));
  }


}
