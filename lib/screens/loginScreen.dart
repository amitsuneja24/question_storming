import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionstorming/services/userAuthentication.dart';
import 'package:country_code_picker/country_code.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _phoneController = TextEditingController();
  TextEditingController userNameController=TextEditingController();
  String countryCode='+91';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 32,horizontal: 22),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

                  SizedBox(height: 16,),
//                  InternationalPhoneNumberInput(
//
//                    onInputChanged: (PhoneNumber phone){
//                      print(phone.phoneNumber);
//                    },
//                    isEnabled: true,
//                    initialValue:number ,
//                    textFieldController: _phoneController,
//                    onSubmit: (){
//                      loginUser(_phoneController.text, context);
//                    },
//
//                  ),


                  Row(
                    children: <Widget>[
                      CountryCodePicker(
                        onChanged: (CountryCode code){
                          countryCode=code.dialCode;
                        },
                        initialSelection: 'IN',
                        onInit: (CountryCode code){
                          countryCode=code.dialCode;
                        },
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top:0,left: 0,right: 0,bottom: 0),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(color: Colors.grey[200])
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(color: Colors.grey[300])
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: "Mobile Number"

                            ),
                            controller: _phoneController,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16,),


                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("LOGIN"),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        final phone = countryCode+_phoneController.text.trim();
                        print(phone);
                        loginUser(phone, context);

                      },
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
  _ShowFormInDialog(BuildContext context) {
    var firestoreDb = Firestore.instance.collection('user');


    return showDialog(

        context: context, barrierDismissible: true, builder: (param) =>
        AlertDialog(
          actions: <Widget>[
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                if(userNameController.text!=null)
                  await  firestoreDb.document().setData({'Questions':{'${userNameController.text}':List()}},merge:true);
//                  await  firestoreDb.document(name).setData({'Questions':[{'${subjectDetailController.text}':[]}]},merge:true);
                userNameController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
                userNameController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
          title: Text("Add Question"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: userNameController,
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

