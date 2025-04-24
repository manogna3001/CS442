import 'package:collection/collection.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class Dice {
  final List<int?> _values;
  final List<bool> _held;

  Dice(int numDice) 
  : _values = List<int?>.filled(numDice, null),
    _held = List<bool>.filled(numDice, false);

  List<int> get values => List<int>.unmodifiable(_values.whereNotNull());

  int? operator [](int index) => _values[index];

  bool isHeld(int index) => _held[index];

  void clear() {
    for (var i = 0; i < _values.length; i++) {
      _values[i] = null;
      _held[i] = false;
    }
  }

  void roll() {
    for (var i = 0; i < _values.length; i++) {
      if (!_held[i]) {
        _values[i] = Random().nextInt(6) + 1;
      }
    }
  }

  void toggleHold(int index) {
    _held[index] = !_held[index];
  }
}

class DiceModel with ChangeNotifier {
  final Dice _dice;
  int rollcount;
  bool hasRolled = false;
  bool canHoldDice = true; 

  DiceModel() : _dice = Dice(5), rollcount = 3;

  List<int?> get values => _dice.values;

  bool isHeld(int index) => _dice.isHeld(index);

  void toggleHold(int index) {
    if (canHoldDice) {
      _dice.toggleHold(index);
      notifyListeners();
    }
  }

  void rollDice() {
    if (rollcount > 0) {
      _dice.roll();
      rollcount -= 1;
      hasRolled = true;
      canHoldDice = true; 
      notifyListeners();
    }
  }

  void clear() {
    for (int i = 0; i < _dice._held.length; i++) {
      _dice._held[i] = false; 
    }
    _dice.clear();
    rollcount = 3;
    hasRolled = false;
    canHoldDice = false; 
    notifyListeners();
  }
}