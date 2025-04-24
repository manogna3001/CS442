import 'package:flutter/material.dart';
import 'package:cs442_mp3/models/dice.dart';
import 'panel_dice.dart';
import 'button_roll.dart';

class DiceDisplay extends StatefulWidget {
  final DiceModel dice;

  const DiceDisplay({super.key, required this.dice});

  @override
  State<DiceDisplay> createState() => _DiceDisplayState();
}

class _DiceDisplayState extends State<DiceDisplay> {
  DiceModel get _dice => widget.dice; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: ListenableBuilder(
          listenable: _dice,
          builder: (BuildContext context, Widget? child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_dice.values.length, (index) {
                    return DicePanel(
                      index: index,
                      dievalue: _dice.values[index] ?? 1,
                      dice: _dice,
                    );
                  }),
                ),
                const SizedBox(height: 10),

                RollButton(
                  count: _dice.rollcount,
                  onPressed: () => _dice.rollDice(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
