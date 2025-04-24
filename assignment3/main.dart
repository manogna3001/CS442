import 'package:flutter/material.dart';
import 'views/yahtzee.dart';

void main() {
  runApp(MaterialApp(
    title: 'Yahtzee',
    home: Scaffold(
      body: Yahtzee()
    ),
    debugShowCheckedModeBanner: false 
  ));
}
