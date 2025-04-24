import 'dart:convert';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/game_screen.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:battleships/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GamesListPage extends StatefulWidget {
  final String baseUrl = "http://165.227.117.48/games";
  final bool isActive;
  final List<int> statusList;

  GamesListPage({Key? key, required this.isActive})
      : statusList = isActive ? [0, 3] : [1, 2],
        super(key: key);

  @override
  State createState() => _GamesListPageState();
}

class _GamesListPageState extends State<GamesListPage> {
  Future<List<dynamic>>? futureGames;
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserName();
    futureGames = _loadGames();
  }

  Future<void> loadUserName() async {
    String sessionUserName = await SessionManager.getSessionUserName();
    setState(() {
      userName = sessionUserName;
    });
  }

  Future<List<dynamic>> _loadGames() async {
    List<dynamic> games = [];

    final response = await http.get(
      Uri.parse(widget.baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await SessionManager.getSessionToken()}',
      },
    );

    if (response.statusCode == 200) {
      final games = json.decode(response.body)['games'];
      return games;
    } else if (response.statusCode == 401) {
      _doLogout();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
    return games;
  }

  Future<void> _refreshGames() async {
    setState(() {
      futureGames = _loadGames();
    });
  }

  Future<String> _deleteGame(int id) async {
    final response = await http.delete(
      Uri.parse('${widget.baseUrl}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await SessionManager.getSessionToken()}',
      },
    );
    String message = "";
    final deletion = json.decode(response.body);
    if (response.statusCode == 200) {
      if (deletion['message'] != null) {
        message = deletion['message'];
      }
    } else if (response.statusCode == 401) {
      _doLogout();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(deletion['error'])),
      );
    }
    _refreshGames();
    return message;
  }

  Future<void> _doLogout() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isActive ? "Active Games" : "Completed Games",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => _refreshGames(),
          )
        ],
      ),
      drawer:
          widget.isActive ? Menu(activepage: false) : Menu(activepage: true),
      body: FutureBuilder<List<dynamic>>(
        future: futureGames,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final game = snapshot.data![index];
                int status = game['status'];

                // Data preparation for display from response
                String gameInfo = game['player2'] == null
                    ? 'Waiting for opponent'
                    : '${game['player1']} Vs ${game['player2']}';

                String gameStatus = "";
                switch (status) {
                  case 0:
                    gameStatus = "Matchmaking";
                    break;
                  case 3:
                    gameStatus = (game['turn'] == 1 &&
                                game['player1'] == userName ||
                            game['turn'] == 2 && game['player2'] == userName)
                        ? "My turn"
                        : "Opponent's turn";
                    break;
                  case 1:
                    gameStatus = game['player1'] == userName ? 'Won' : 'Lost';
                    break;
                  case 2:
                    gameStatus = game['player2'] == userName ? 'Won' : 'Lost';
                    break;
                }

                // Determine background color based on active or completed status
                final cardColor =
                    widget.isActive ? Colors.green[100] : Colors.red[100];

                if (widget.statusList.contains(status)) {
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: widget.isActive
                        ? Dismissible(
                            key: Key(game['id'].toString()),
                            onDismissed: (_) async {
                              snapshot.data!.removeAt(index);
                              final message = await _deleteGame(game['id']);
                              if (message == "Game forfeited") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Game forfeited")),
                                );
                              }
                            },
                            background: Container(
                              color: Colors.redAccent,
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                gameInfo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                gameStatus,
                                style: TextStyle(
                                  color: gameStatus == 'My turn'
                                      ? Colors.green
                                      : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              trailing: Text(
                                "ID: ${game['id']}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                if (status == 0) {
                                  // Show message if game is still in "Matchmaking" status
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Match is yet to be found. Please wait."),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Navigate to the game screen if not in "Matchmaking"
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute<String>(
                                          builder: (context) => GameScreen(
                                              gameId: game['id']),
                                        ),
                                      )
                                      .then((value) {
                                    _refreshGames();
                                  });
                                }
                              },
                            ),
                          )
                        : ListTile(
                            title: Text(
                              gameInfo,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              gameStatus,
                              style: TextStyle(
                                color: gameStatus == 'Won'
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                              "ID: ${game['id']}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            onTap: () {
                              if (status == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Match is yet to be found. Please wait."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute<String>(
                                        builder: (context) =>
                                            GameScreen(gameId: game['id']),
                                      ),
                                    )
                                    .then((value) {
                                  _refreshGames();
                                });
                              }
                            },
                          ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }
        },
      ),
    );
  }
}
