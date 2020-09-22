import 'package:flutter/material.dart';
import 'package:questionstorming/screens/home.dart';
import 'package:questionstorming/screens/loginScreen.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
