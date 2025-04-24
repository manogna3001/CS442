import 'package:flutter/material.dart';
import 'package:cs442_mp3/models/dice.dart';

class DicePanel extends StatelessWidget {
  final int dievalue;
  final DiceModel dice;
  final int index;

  const DicePanel({super.key, required this.index, required this.dievalue, required this.dice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dice.toggleHold(index); // Only toggle if holding dice is allowed
      }, 
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dice.isHeld(index) ? Colors.redAccent : const Color.fromARGB(255, 249, 251, 250),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: dice.isHeld(index) 
                ? Colors.red 
                : Colors.green, // Highlight held dice in red
            width: 2.0,
          ),
        ),
        child: Text(
          '$dievalue',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
