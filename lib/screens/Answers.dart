import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Answers extends StatefulWidget {
  CollectionReference firebasedb;
  String name;
  int topIndex;
  int baseindex;
  Answers({this.firebasedb,this.name,this.topIndex,this.baseindex
  });
  @override
  _AnswersState createState() => _AnswersState(firebasedb: firebasedb,topIndex: topIndex,baseindex: baseindex,name: name);
}

class _AnswersState extends State<Answers> {
  CollectionReference firebasedb;
  int topIndex;
  String name;
  int baseindex;
  _AnswersState({this.firebasedb,this.name,this.topIndex,this.baseindex});
  TextEditingController answerController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Answers"),
      ),
      body: StreamBuilder(
        stream: firebasedb.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){

          print(topIndex);
              // print(baseindex);
               List questionList =
               snapshot.data.documents[baseindex].data['Questions']?.keys?.toList();
          List answerList = snapshot
              .data?.documents[baseindex].data['Questions']?.values
              ?.toList();
          int noOfAnswers=answerList[topIndex].length;

          return Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${questionList[topIndex]}",style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold),),
                ),
              ),
              Expanded(
                child: ListView.builder(itemCount:answerList[topIndex].length,itemBuilder: (context,int index){
                  print("ok");
                  print(noOfAnswers);
                  print("################################################################");
                  return (noOfAnswers!=0)?Container(height: 30,width: double.infinity,
                  child: Center(child: Text('${answerList[topIndex][index].values.toList()[0]}'),),):Center(
                      child: Text(
                        "No Questions Yet",
                        style: TextStyle(fontSize: 30),
                      ));
                }),
              ),

                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: "Answer",
                  ),
                ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
              ),

              RaisedButton( child: Text("Save"),
                onPressed: () async {
                  if ((answerController.text != null)&&(nameController.text!=null))
                    await firebasedb.document(name).setData({
                      'Questions': {
                        '${questionList[topIndex]}': FieldValue.arrayUnion([{'${nameController.text}':'${answerController.text}'}])
                    }},merge: true);
                  answerController.clear();
                  nameController.clear();
                 // Navigator.of(context).pop();
                },)
            ],
          );
        },

      ),
    );}
}
