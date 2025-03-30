import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/question_bottom_sheet.dart';
import '../widgets/health_display.dart';
import '../widgets/floor_selector_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _showQuestionBottomSheet(BuildContext context, int floor, int section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuestionBottomSheet(
        floor: floor,
        section: section,
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

  void _showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You have lost all your health points. Would you like to restart the game?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to main menu
            },
            child: const Text('Main Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<GameState>().resetGame(); // Reset game state
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text(
          'LSU PFT Scavenger Hunt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
          // Check for game over condition
          if (gameState.health <= 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showGameOverDialog(context);
            });
          }

          if (gameState.showCongrats) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCongratsDialog(context);
            });
          }

          return Stack(
            children: [
              // Interactive Map
              Positioned.fill(
                child: GestureDetector(
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
                    _getSectionImage(gameState),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Floor Selector Button
              const FloorSelectorButton(),
              // Bottom Sheet
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                      color: const Color(0xFFFDD023),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Floor ${gameState.currentFloor}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF461D7C),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDD023),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: Color(0xFF461D7C),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${gameState.helpers}',
                                  style: const TextStyle(
                                    color: Color(0xFF461D7C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: gameState.unlockedSections[gameState.currentFloor]!
                            .where((section) => section)
                            .length /
                            4,
                        minHeight: 6,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF461D7C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getSectionImage(GameState gameState) {
    final currentFloor = gameState.currentFloor;
    final unlockedSections = gameState.unlockedSections[currentFloor]!;
    final allSectionsUnlocked = unlockedSections.every((section) => section);

    return allSectionsUnlocked 
        ? 'assets/floors/unlocked_floor$currentFloor.png'
        : 'assets/floors/locked_floor$currentFloor.png';
  }
} 