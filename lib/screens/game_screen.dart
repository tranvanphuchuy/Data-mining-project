import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/question_bottom_sheet.dart';
import '../widgets/health_display.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _showQuestionBottomSheet(BuildContext context, int floor, int section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => QuestionBottomSheet(
          floor: floor,
          section: section,
        ),
      ),
    );
  }

  void _showCongratsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                color: Color(0xFFFDD023),
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF461D7C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You\'ve completed this floor!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<GameState>().dismissCongrats();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF461D7C),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LSU PFT Scavenger Hunt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF461D7C),
        actions: const [
          HealthDisplay(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameState.showCongrats) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCongratsDialog(context);
            });
          }

          return Stack(
            children: [
              // Interactive Map
              GestureDetector(
                onTapUp: (TapUpDetails details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.globalPosition);
                  final width = box.size.width;
                  final height = box.size.height;

                  // Calculate which quarter was tapped
                  final isLeftSide = localPosition.dx < width / 2;
                  final isTopHalf = localPosition.dy < height / 2;

                  int sectionIndex;
                  if (isTopHalf && isLeftSide) sectionIndex = 0;
                  else if (isTopHalf && !isLeftSide) sectionIndex = 1;
                  else if (!isTopHalf && isLeftSide) sectionIndex = 2;
                  else sectionIndex = 3;

                  // Show question for the tapped section
                  _showQuestionBottomSheet(
                    context,
                    gameState.currentFloor,
                    sectionIndex,
                  );
                },
                child: Image.asset(
                  'assets/floors/locked_floor${gameState.currentFloor}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<GameState>().currentFloor - 1,
        onTap: (index) {
          final targetFloor = index + 1;
          if (targetFloor == 1 || 
              (targetFloor > 1 && context.read<GameState>().getFloorState(targetFloor - 1) == FloorState.unlocked)) {
            context.read<GameState>().setCurrentFloor(targetFloor);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.looks_one),
            label: 'Floor 1',
            backgroundColor: const Color(0xFF461D7C),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.looks_two,
              color: context.watch<GameState>().getFloorState(1) == FloorState.unlocked 
                  ? Colors.white 
                  : Colors.grey,
            ),
            label: 'Floor 2',
            backgroundColor: const Color(0xFF461D7C),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.looks_3,
              color: context.watch<GameState>().getFloorState(2) == FloorState.unlocked 
                  ? Colors.white 
                  : Colors.grey,
            ),
            label: 'Floor 3',
            backgroundColor: const Color(0xFF461D7C),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Consumer<GameState>(
          builder: (context, gameState, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Floor ${gameState.currentFloor}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF461D7C),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDD023),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lightbulb,
                          color: Color(0xFF461D7C),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.helpers}',
                          style: const TextStyle(
                            color: Color(0xFF461D7C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: gameState.unlockedSections[gameState.currentFloor]!
                    .where((section) => section)
                    .length /
                    4,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF461D7C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 