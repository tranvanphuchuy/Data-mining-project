import 'package:flutter/foundation.dart';

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
  int _helpers = 0;
  int _correctAnswers = 0;
  bool _showCongrats = false;

  int get currentFloor => _currentFloor;
  Map<int, FloorState> get floorStates => _floorStates;
  Map<int, List<bool>> get unlockedSections => _unlockedSections;
  int get helpers => _helpers;
  int get correctAnswers => _correctAnswers;
  bool get showCongrats => _showCongrats;

  void unlockSection(int floor, int section) {
    if (_unlockedSections[floor] != null && section < _unlockedSections[floor]!.length) {
      _unlockedSections[floor]![section] = true;
      _checkFloorCompletion();
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
    for (int floor = 1; floor <= 3; floor++) {
      if (_unlockedSections[floor]?.every((section) => section) ?? false) {
        if (floor < 3) {
          _floorStates[floor] = FloorState.unlocked;
          _currentFloor = floor + 1;
          _showCongrats = true;
          Future.delayed(const Duration(seconds: 3), () {
            _showCongrats = false;
            notifyListeners();
          });
          notifyListeners();
        }
      }
    }
  }

  void dismissCongrats() {
    _showCongrats = false;
    notifyListeners();
  }
} 