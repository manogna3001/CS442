import 'package:flutter/material.dart';
import 'package:cs442_mp3/models/dice.dart';
import '../models/scorecard.dart';
import 'panel_scorecard.dart';

class ScorecardDisplay extends StatefulWidget {
  final DiceModel dice;

  const ScorecardDisplay({super.key, required this.dice});

  @override
  State<ScorecardDisplay> createState() => _ScorecardDisplayState();
}

class _ScorecardDisplayState extends State<ScorecardDisplay> {
  final ScorecardModel scorecard = ScorecardModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: ListenableBuilder(
          listenable: widget.dice, 
          builder: (BuildContext context, Widget? child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        for (final category in ScoreCategory.values)
                          if (category.index < 6)
                            ScorecardPanel(
                              name: category.name,
                              value: scorecard.scorecard[category],
                              onTap: () => _onCategorySelect(category),
                              isEnabled: widget.dice.hasRolled, 
                            ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Column(
                      children: [
                        for (final category in ScoreCategory.values)
                          if (category.index >= 6)
                            ScorecardPanel(
                              name: category.name,
                              value: scorecard.scorecard[category],
                              onTap: () => _onCategorySelect(category),
                              isEnabled: widget.dice.hasRolled,
                            ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Current Score: ${scorecard.total}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 4, 167, 242),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onCategorySelect(ScoreCategory category) {
    if (widget.dice.hasRolled) {
      
      scorecard.updatescore(category, widget.dice, context);

      setState(() {
        widget.dice.clear(); 
        widget.dice.hasRolled = false; 
        
        // Hide the dice visually by setting them to null
        for (int i = 0; i < widget.dice.values.length; i++) {
          widget.dice.values[i] = null;
        }
      });
    }
  }
}
