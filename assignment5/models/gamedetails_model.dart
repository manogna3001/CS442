class GameDetailsModel {
  int id;
  String player1;
  String player2;
  int position;
  List<String> ships;
  List<String> shots;
  int status;
  List<String> sunk;
  int turn;
  List<String> wrecks;

  GameDetailsModel(
      {required this.id,
      required this.player1,
      required this.player2,
      required this.position,
      required this.ships,
      required this.shots,
      required this.status,
      required this.sunk,
      required this.turn,
      required this.wrecks});

  factory GameDetailsModel.fromJson(Map<String, dynamic> game) {
    int id = game['id'];
    String player1 = game['player1'];
    String player2 = game['player2'];
    int position = game['position'];
    int status = game['status'];
    int turn = game['turn'];
    List<String> ships =
        (game['ships'] as List).map((e) => e as String).toList();
    List<String> shots =
        (game['shots'] as List).map((e) => e as String).toList();
    List<String> sunk = (game['sunk'] as List).map((e) => e as String).toList();
    List<String> wrecks =
        (game['wrecks'] as List).map((e) => e as String).toList();

    return GameDetailsModel(
        id: id,
        player1: player1,
        player2: player2,
        position: position,
        ships: ships,
        shots: shots,
        status: status,
        sunk: sunk,
        turn: turn,
        wrecks: wrecks);
  }
}