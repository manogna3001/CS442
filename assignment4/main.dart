import 'package:flutter/material.dart';
import 'models/alldecks.dart';
import 'views/decklist_page.dart';
import 'package:provider/provider.dart';

void main()  {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => DecksAll(),
        child: const DeckListPage(),
      )));
}