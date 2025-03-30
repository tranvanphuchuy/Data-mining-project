import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class HealthDisplay extends StatelessWidget {
  const HealthDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Row(
          children: [
            // Health Hearts
            Row(
              children: List.generate(10, (index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    index < gameState.health ? Icons.favorite : Icons.favorite_border,
                    color: index < gameState.health ? Colors.red : Colors.grey,
                    key: ValueKey('heart_$index'),
                  ),
                );
              }),
            ),
            const SizedBox(width: 16),
            // Rules Button
            IconButton(
              icon: const Icon(Icons.help_outline),
              color: Colors.white,
              onPressed: () => _showRulesDialog(context),
            ),
          ],
        );
      },
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Rules'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRuleItem('Start with 10 health points'),
              _buildRuleItem('Each wrong answer costs 1 health point'),
              _buildRuleItem('Answer 3 questions correctly to earn a helper'),
              _buildRuleItem('Use helpers to get hints or remove wrong answers'),
              _buildRuleItem('Unlock all sections on a floor to progress'),
              _buildRuleItem('Complete all 3 floors to win the game'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF461D7C)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
} 