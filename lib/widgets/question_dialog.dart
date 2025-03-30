import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/questions.dart';

class QuestionDialog extends StatefulWidget {
  final int floor;
  final int section;

  const QuestionDialog({
    super.key,
    required this.floor,
    required this.section,
  });

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  int? selectedAnswer;
  bool usedHelper = false;
  List<int> eliminatedOptions = [];

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final questionsAnswered = gameState.getQuestionsAnswered(widget.floor, widget.section);
    final question = Questions.getQuestion(widget.floor, widget.section, questionsAnswered);

    return AlertDialog(
      title: Text('Section ${widget.section + 1} Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.question),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              if (eliminatedOptions.contains(entry.key)) {
                return const SizedBox.shrink();
              }
              return RadioListTile<int>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value;
                  });
                },
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
          ],
        ),
      ),
      actions: [
        Consumer<GameState>(
          builder: (context, gameState, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (gameState.helpers > 0 && !usedHelper)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        usedHelper = true;
                        gameState.useHelper();
                      });
                    },
                    icon: const Icon(Icons.lightbulb),
                    label: const Text('Use Helper'),
                  ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: selectedAnswer == null
                          ? null
                          : () {
                              if (selectedAnswer == question.correctAnswer) {
                                gameState.incrementCorrectAnswers();
                                gameState.unlockSection(
                                  widget.floor,
                                  widget.section,
                                );
                              }
                              Navigator.pop(context);
                            },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
} 