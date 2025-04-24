import 'package:flutter/material.dart';
import '../models/dice.dart';
import '../models/scorecard.dart';
import 'display_dice.dart';
import 'display_scorecard.dart';

class Yahtzee extends StatelessWidget {
  Yahtzee({super.key});
  final DiceModel _dice = DiceModel();
 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, 
        centerTitle: true, 
        title: const Text('Yahtzee Game', style: TextStyle(color: Colors.white)), 
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // Dice display in rounded squares
              DiceDisplay(dice: _dice),
              const SizedBox(height: 20), 
              ScorecardDisplay(dice: _dice),
            ],
          ),
        ),
      ),
    );
  }
}

class GameoverAlert {
  Future<void> gameover(BuildContext context, ScoreCard scorecard) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over! '),
          content: Text('Final Score : ${scorecard.total}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Play again! '),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          elevation: 20,
          backgroundColor: const Color.fromARGB(255, 159, 204, 238),
        );
      },
    );
  }
}