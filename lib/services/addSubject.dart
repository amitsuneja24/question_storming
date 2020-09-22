import 'package:flutter/material.dart';
class AddSubject extends StatelessWidget {
  TextEditingController subjectController = TextEditingController();
  _ShowFormInDialog(BuildContext context) {
    return showDialog(
        context: context, barrierDismissible: true, builder: (param) =>
        AlertDialog(
          actions: <Widget>[
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {

                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
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
                      labelText: "Category Id",
                      hintText: "Enter Category ID"
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

