import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'dart:math';

class HealthDisplay extends StatelessWidget {
  const HealthDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(10, (index) {
            final isActive = index < gameState.health;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: isActive ? 1.0 : 0.8,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isActive ? 1.0 : 0.5,
                  child: Icon(
                    Icons.favorite,
                    color: isActive ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            );
          }),
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