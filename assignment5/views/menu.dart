import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/games_list_page.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:battleships/views/game_screen.dart';
import 'package:flutter/material.dart';

/// Very similar to main screen in eg2.dart, but with authentication.
class Menu extends StatefulWidget {
  bool activepage;
  Menu({super.key, required this.activepage});

  @override
  State createState() => _MenuState();
}

class _MenuState extends State<Menu> {
 
  void toggleGamesList() {
    setState(() {
      widget.activepage = !widget.activepage;
    });
  }

  Future<void> _doLogout(BuildContext context) async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(      
      builder: (_) => const LoginScreen()
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[100],  // Light background for drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Center(
                child: Text(
                  "Battleships",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.deepPurple),
              title: const Text("New Game Human", style: TextStyle(fontSize: 16)),
              onTap: () {    
                Navigator.pop(context);   
                Navigator.of(context).push(MaterialPageRoute<String>(
                  builder: (context) => const GameScreen(gameId: 0),
                ));
              },
            ),
            Builder(
              builder: (context) => ExpansionTile(
                leading: const Icon(Icons.smart_toy, color: Colors.deepPurple),
                title: const Text("New Game (AI)", style: TextStyle(fontSize: 16)),
                childrenPadding: const EdgeInsets.only(left: 16),
                children: [
                  ListTile(
                    leading: const Icon(Icons.shuffle, color: Colors.deepPurple),
                    title: const Text("Random", style: TextStyle(fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute<String>(
                        builder: (context) => const GameScreen(gameId: 0, aiGameType: 'random'),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.deepPurple),
                    title: const Text("Perfect", style: TextStyle(fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute<String>(
                        builder: (context) => const GameScreen(gameId: 0, aiGameType: 'perfect'),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.adjust, color: Colors.deepPurple),
                    title: const Text("One Ship AI", style: TextStyle(fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute<String>(
                        builder: (context) => const GameScreen(gameId: 0, aiGameType: 'oneship'),
                      ));
                    },
                  ),
                ],
              ),
            ),
            widget.activepage
              ? ListTile(
                  leading: const Icon(Icons.games, color: Colors.green),
                  title: const Text("Show Active Games", style: TextStyle(fontSize: 16)),           
                  onTap: () {   
                    Navigator.pop(context);           
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamesListPage(isActive: true),
                    )); 
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.red),
                  title: const Text("Show Completed Games", style: TextStyle(fontSize: 16)),           
                  onTap: () {              
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamesListPage(isActive: false),
                    ));
                  },
                ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.purple),
              title: const Text("Log out", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);              
                _doLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
