import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum FloorState {
  locked,
  split,
  unlocked,
}

class GameState extends ChangeNotifier {
  int _currentFloor = 1;
  Map<int, FloorState> _floorStates = {
    1: FloorState.locked,
    2: FloorState.locked,
    3: FloorState.locked,
  };
  Map<int, List<bool>> _unlockedSections = {
    1: [false, false, false, false],
    2: [false, false, false, false],
    3: [false, false, false, false],
  };
  
  // Track questions answered per section
  Map<String, int> _questionsAnswered = {};
  
  int _helpers = 0;
  int _correctAnswers = 0;
  bool _showCongrats = false;
  int _health = 10;
  bool _showRules = false;

  int get currentFloor => _currentFloor;
  Map<int, FloorState> get floorStates => _floorStates;
  Map<int, List<bool>> get unlockedSections => _unlockedSections;
  int get helpers => _helpers;
  int get correctAnswers => _correctAnswers;
  bool get showCongrats => _showCongrats;
  int get health => _health;
  bool get showRules => _showRules;

  void setCurrentFloor(int floor) {
    if (floor >= 1 && floor <= 3) {
      _currentFloor = floor;
      notifyListeners();
    }
  }

  void unlockSection(int floor, int section) {
    if (_unlockedSections[floor] != null && section < _unlockedSections[floor]!.length) {
      _unlockedSections[floor]![section] = true;
      if (floor == _currentFloor) {
        _checkFloorCompletion();
      }
      notifyListeners();
    }
  }

  void incrementCorrectAnswers() {
    _correctAnswers++;
    _helpers = (_correctAnswers / 3).floor();
    notifyListeners();
  }

  void useHelper() {
    if (_helpers > 0) {
      _helpers--;
      notifyListeners();
    }
  }

  void loseHealth() {
    if (_health > 0) {
      _health--;
      notifyListeners();
    }
  }

  void toggleRules() {
    _showRules = !_showRules;
    notifyListeners();
  }

  bool isSectionUnlocked(int floor, int section) {
    return _unlockedSections[floor]?[section] ?? false;
  }

  FloorState getFloorState(int floor) {
    return _floorStates[floor] ?? FloorState.locked;
  }

  void splitFloor(int floor) {
    if (_floorStates[floor] == FloorState.locked) {
      _floorStates[floor] = FloorState.split;
      notifyListeners();
    }
  }

  void _checkFloorCompletion() {
    if (_unlockedSections[_currentFloor]?.every((section) => section) ?? false) {
      if (_currentFloor < 3) {
        _floorStates[_currentFloor] = FloorState.unlocked;
        _floorStates[_currentFloor + 1] = FloorState.split;
        _currentFloor = _currentFloor + 1;
        _showCongrats = true;
        Future.delayed(const Duration(seconds: 3), () {
          _showCongrats = false;
          notifyListeners();
        });
        notifyListeners();
      }
    }
  }

  void dismissCongrats() {
    _showCongrats = false;
    notifyListeners();
  }

  int getQuestionsAnswered(int floor, int section) {
    final key = '${floor}_$section';
    return _questionsAnswered[key] ?? 0;
  }

  void incrementQuestionsAnswered(int floor, int section) {
    final key = '${floor}_$section';
    _questionsAnswered[key] = (_questionsAnswered[key] ?? 0) + 1;
    
    // If 2 questions are answered correctly for this section, unlock it
    if (_questionsAnswered[key] == 2) {
      unlockSection(floor, section);
    }
    notifyListeners();
  }

  void resetGame() {
    _health = 10;
    _currentFloor = 1;
    _correctAnswers = 0;
    _helpers = 0;
    _questionsAnswered = {};
    _unlockedSections = {
      1: [false, false, false, false],
      2: [false, false, false, false],
      3: [false, false, false, false],
    };
    notifyListeners();
  }

  void unlockFloor(int floor) {
    if (floor >= 1 && floor <= 3) {
      _floorStates[floor] = FloorState.unlocked;
      _unlockedSections[floor] = List.generate(4, (index) => false);
      notifyListeners();
    }
  }
} 
