import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/section_card.dart';
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
        title: const Text('LSU PFT Scavenger Hunt'),
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
              // Floor Image Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/floors/floor${gameState.currentFloor}.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Semi-transparent overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Floor ${gameState.currentFloor}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: const Color(0xFF461D7C),
                                    fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: gameState.getFloorState(gameState.currentFloor) == FloorState.locked ? 1 : 4,
                        itemBuilder: (context, index) {
                          if (gameState.getFloorState(gameState.currentFloor) == FloorState.locked) {
                            return SectionCard(
                              sectionNumber: 1,
                              isUnlocked: false,
                              floorState: FloorState.locked,
                              onTap: () {
                                gameState.splitFloor(gameState.currentFloor);
                              },
                            );
                          }

                          return SectionCard(
                            sectionNumber: index + 1,
                            isUnlocked: gameState.isSectionUnlocked(
                              gameState.currentFloor,
                              index,
                            ),
                            floorState: gameState.getFloorState(gameState.currentFloor),
                            onTap: () {
                              if (gameState.isSectionUnlocked(
                                gameState.currentFloor,
                                index,
                              )) {
                                _showQuestionBottomSheet(
                                  context,
                                  gameState.currentFloor,
                                  index,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<GameState>(
        builder: (context, gameState, child) {
          return BottomNavigationBar(
            currentIndex: gameState.currentFloor - 1,
            onTap: (index) {
              final targetFloor = index + 1;
              // Only allow navigation to unlocked floors
              if (targetFloor == 1 || 
                  (targetFloor > 1 && gameState.getFloorState(targetFloor - 1) == FloorState.unlocked)) {
                gameState.setCurrentFloor(targetFloor);
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
                  color: gameState.getFloorState(1) == FloorState.unlocked 
                      ? Colors.white 
                      : Colors.grey,
                ),
                label: 'Floor 2',
                backgroundColor: const Color(0xFF461D7C),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.looks_3,
                  color: gameState.getFloorState(2) == FloorState.unlocked 
                      ? Colors.white 
                      : Colors.grey,
                ),
                label: 'Floor 3',
                backgroundColor: const Color(0xFF461D7C),
              ),
            ],
          );
        },
      ),
    );
  }
} 