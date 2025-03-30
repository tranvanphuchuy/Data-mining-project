import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/game_state.dart';
import '../models/questions.dart';

class QuestionBottomSheet extends StatefulWidget {
  final int floor;
  final int section;

  const QuestionBottomSheet({
    super.key,
    required this.floor,
    required this.section,
  });

  @override
  State<QuestionBottomSheet> createState() => _QuestionBottomSheetState();
}

class _QuestionBottomSheetState extends State<QuestionBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _shakeAnimation;
  int? selectedAnswer;
  bool usedHelper = false;
  bool isAnswerSubmitted = false;
  bool isCorrect = false;
  Set<int> wrongAnswers = {};  // Track wrong answers

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAnswerSelection(int answer) {
    if (isAnswerSubmitted) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _handleSubmit() {
    if (selectedAnswer == null) return;

    final gameState = context.read<GameState>();
    final questionsAnswered = gameState.getQuestionsAnswered(widget.floor, widget.section);
    final question = Questions.getQuestion(widget.floor, widget.section, questionsAnswered);
    final isCorrectAnswer = selectedAnswer == question.correctAnswer;

    if (isCorrectAnswer) {
      setState(() {
        isAnswerSubmitted = true;
        isCorrect = true;
      });

      // Show success animation and transition to next question
      Future.delayed(const Duration(milliseconds: 1000), () {
        context.read<GameState>().incrementCorrectAnswers();
        context.read<GameState>().incrementQuestionsAnswered(widget.floor, widget.section);
        
        // Check if there are more questions for this section
        if (questionsAnswered < 1) {
          // Reset state for next question
          setState(() {
            selectedAnswer = null;
            isAnswerSubmitted = false;
            isCorrect = false;
            wrongAnswers.clear();
            usedHelper = false;
          });
          // Show next question
          _showNextQuestion();
        } else {
          // Check if all sections are completed
          final allSectionsCompleted = gameState.unlockedSections[widget.floor]!.every((section) => section);
          if (allSectionsCompleted) {
            // Unlock next floor if available
            if (widget.floor < 3) {
              gameState.unlockFloor(widget.floor + 1);
            }
          }
          // Close the bottom sheet
          Navigator.pop(context);
        }
      });
    } else {
      setState(() {
        wrongAnswers.add(selectedAnswer!);
        selectedAnswer = null;  // Reset selection for next attempt
      });
      
      context.read<GameState>().loseHealth();
      // Trigger shake animation with smoother motion
      _controller.reset();
      _controller.forward();
    }
  }

  void _showNextQuestion() {
    // Rebuild the bottom sheet with the next question
    setState(() {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final questionsAnswered = gameState.getQuestionsAnswered(widget.floor, widget.section);
    final question = Questions.getQuestion(widget.floor, widget.section, questionsAnswered);

    // If this section is already completed (both questions answered), show a message
    if (questionsAnswered >= 2) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: const Border(
            top: BorderSide(
              color: Color(0xFFFDD023),
              width: 2,
            ),
            left: BorderSide(
              color: Color(0xFFFDD023),
              width: 2,
            ),
            right: BorderSide(
              color: Color(0xFFFDD023),
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Section ${widget.section + 1} Completed!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF461D7C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have completed all questions for this section.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: const Border(
                top: BorderSide(
                  color: Color(0xFFFDD023),
                  width: 2,
                ),
                left: BorderSide(
                  color: Color(0xFFFDD023),
                  width: 2,
                ),
                right: BorderSide(
                  color: Color(0xFFFDD023),
                  width: 2,
                ),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF461D7C),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Section ${widget.section + 1} Question',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Question ${questionsAnswered + 1} of 2',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (!isAnswerSubmitted && gameState.helpers > 0 && !usedHelper)
                        IconButton(
                          icon: const Icon(Icons.lightbulb, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              usedHelper = true;
                              gameState.useHelper();
                            });
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...question.options.asMap().entries.map((entry) {
                        final isSelected = selectedAnswer == entry.key;
                        final isCorrectAnswer = entry.key == question.correctAnswer;
                        final showCorrect = isAnswerSubmitted && isCorrectAnswer;
                        final isWrongAnswer = wrongAnswers.contains(entry.key);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  isWrongAnswer && isSelected 
                                      ? sin(_shakeAnimation.value * 5 * pi) * 8 
                                      : 0,
                                  0,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: showCorrect
                                          ? Colors.green
                                          : isWrongAnswer
                                              ? Colors.red
                                              : isSelected
                                                  ? const Color(0xFF461D7C)
                                                  : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: isAnswerSubmitted || isWrongAnswer
                                        ? null
                                        : () => _handleAnswerSelection(entry.key),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: showCorrect
                                          ? Colors.green
                                          : isWrongAnswer
                                              ? Colors.red.withOpacity(0.7)
                                              : isSelected
                                                  ? const Color(0xFF461D7C)
                                                  : Colors.white,
                                      foregroundColor: showCorrect || isWrongAnswer || isSelected
                                          ? Colors.white
                                          : const Color(0xFF461D7C),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isWrongAnswer && !isSelected
                                                  ? Colors.red.withOpacity(0.7)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle),
                                        if (isWrongAnswer && !isSelected)
                                          const Icon(Icons.close, color: Colors.red),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      if (question.hint != null && usedHelper)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Hint: ${question.hint}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (!isAnswerSubmitted)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedAnswer == null ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF461D7C),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit Answer',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 