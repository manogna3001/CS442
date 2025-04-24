import 'dart:convert';

import 'package:battleships/model/gamedetails_model.dart';
import 'package:battleships/utils/SessionManager.dart';
import 'package:battleships/views/gamegrid.dart';
import 'package:battleships/views/games_list_page.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameScreen extends StatefulWidget {
  final int gameId;
  final String? aiGameType;

  const GameScreen({required this.gameId, this.aiGameType, super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> fiveShips = List.empty(growable: true);
  final baseUrl = "http://165.227.117.48";
  Future<GameDetailsModel?>? gameDetails;
  String? userName;
  bool isEditable = true;
  String shot = "";

  @override
  void initState() {
    super.initState();
    if (widget.gameId != 0) {
      setState(() {
        loadGame(widget.gameId);
      });
    }
  }

  void loadGame(int id) {
    gameDetails = loadGamesDetails(id);
  }

  Future<GameDetailsModel?> loadGamesDetails(int gameId) async {
    userName = await SessionManager.getSessionUserName();

    final response = await http.get(Uri.parse('$baseUrl/games/$gameId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await SessionManager.getSessionToken()}',
        });

    final game = json.decode(response.body);
    GameDetailsModel? gameModel;

    if (response.statusCode == 200) {
      gameModel = GameDetailsModel.fromJson(game);
    } else if (response.statusCode == 401) {
      _dologout();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
    return gameModel;
  }

  void _dologout() {
    SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Play Game',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 6,
      ),
      body: widget.gameId != 0
          ? FutureBuilder<GameDetailsModel?>(
              future: gameDetails,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final model = snapshot.data;
                  bool isNewGame = false;

                  if (model != null) {
                    int positionOfUser = 0;
                    if (userName == model.player1) {
                      positionOfUser = 1;
                    } else {
                      positionOfUser = 2;
                    }
                    if (model.status == 0 ||
                        model.status == 1 ||
                        model.status == 2) {
                      isEditable = false;
                    } else if (model.status == 3 &&
                        positionOfUser == model.turn) {
                      isEditable = true;
                    } else {
                      isEditable = false;
                    }
                  }
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white, 
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GameGrid(
                                isEditable: isEditable,
                                isNewGame: isNewGame,
                                onTap: setSelectedValues,
                                onClick: playGame,
                                gameDetails: model,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    ),
                  );
                }
              },
            )
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: GameGrid(
                      isEditable: isEditable,
                      isNewGame: true,
                      onTap: setSelectedValues,
                      onClick: playGame,
                      gameDetails: null,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  void setSelectedValues(String value, bool add, bool isNewGame) {
    if (isNewGame) {
      if (add) {
        fiveShips.add(value);
      } else {
        fiveShips.remove(value);
      }
    } else {
      if (add) {
        shot = value;
      } else {
        shot = "";
      }
    }
  }

  void playGame(bool isNewGame, GameDetailsModel? model) {
    if (isNewGame) {
      startGame();
    } else {
      playShot(model);
    }
  }

  void startGame() async {
    int requiredShips = 5;
    int remainingShips = requiredShips - fiveShips.length;

    if (remainingShips > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please add $remainingShips more ship${remainingShips > 1 ? "s" : ""}.',
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
    } else {
      String jsonData = "";
      if (widget.aiGameType != null) {
        jsonData = jsonEncode({'ships': fiveShips, 'ai': widget.aiGameType});
        print('Selected AI Type: ${widget.aiGameType}');

      } else {
        jsonData = jsonEncode({'ships': fiveShips});
      }

      final url = Uri.parse('$baseUrl/games');
      String token = await SessionManager.getSessionToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => GamesListPage(isActive: true),
          ),
        );
      } else if (response.statusCode == 401) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
      }
    }
  }

  void playShot(GameDetailsModel? model) async {
    if (shot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No spot selected to shoot')),
      );
    } else if (model != null) {
      bool shotExists = model.shots.contains(shot);
      if (shotExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shot already exists')),
        );
      } else {
        final url = Uri.parse('$baseUrl/games/${widget.gameId}');
        String token = await SessionManager.getSessionToken();

        final response = await http.put(url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'shot': shot}));

        final game = json.decode(response.body);
        if (response.statusCode == 200) {
          setState(() {
            isEditable = false;
            bool won = game['won'];
            bool sunkShip = game['sunk_ship'];

            if (won) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Game Over'),
                  content: Text(won ? 'You Won' : 'You Lost'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(sunkShip ? 'Ship Sunk' : 'No enemy ship hit'),
              ));
            }
            loadGame(widget.gameId);
          });
        } else if (response.statusCode == 401) {
          _dologout();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')),
          );
        }
      }
    }
  }
}
