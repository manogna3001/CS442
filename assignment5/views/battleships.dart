import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/sessionmanager.dart';
import 'games_list_page.dart';
import 'login_screen.dart';
import 'menu.dart';

class Battleships extends StatefulWidget {
  const Battleships({Key? key});

  @override
  State<Battleships> createState() => _BattleshipsState();
}

class _BattleshipsState extends State<Battleships> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // use SessionManager to check if a user is already logged in
  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battleships',
      // start at either the home or login screen
      home: isLoggedIn ? GamesListPage(isActive: true,) : const LoginScreen(),
    );
  }
}