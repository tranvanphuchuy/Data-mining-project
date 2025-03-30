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
  int? selectedAnswer;
  bool usedHelper = false;
  bool isAnswerSubmitted = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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

    final question = Questions.getQuestion(widget.floor, widget.section);
    final isCorrectAnswer = selectedAnswer == question.correctAnswer;

    setState(() {
      isAnswerSubmitted = true;
      isCorrect = isCorrectAnswer;
    });

    if (isCorrectAnswer) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        context.read<GameState>().incrementCorrectAnswers();
        context.read<GameState>().unlockSection(widget.floor, widget.section);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = Questions.getQuestion(widget.floor, widget.section);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF461D7C),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Section ${widget.section + 1} Question',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isAnswerSubmitted && context.watch<GameState>().helpers > 0 && !usedHelper)
                        IconButton(
                          icon: const Icon(Icons.lightbulb, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              usedHelper = true;
                              context.read<GameState>().useHelper();
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
                        final showWrong = isAnswerSubmitted && isSelected && !isCorrect;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    showWrong ? sin(_controller.value * 10) * 10 : 0,
                                    0,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: isAnswerSubmitted
                                        ? null
                                        : () => _handleAnswerSelection(entry.key),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: showCorrect
                                          ? Colors.green
                                          : showWrong
                                              ? Colors.red
                                              : isSelected
                                                  ? const Color(0xFF461D7C)
                                                  : Colors.white,
                                      foregroundColor: showCorrect || showWrong || isSelected
                                          ? Colors.white
                                          : const Color(0xFF461D7C),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: isSelected
                                              ? const Color(0xFF461D7C)
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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