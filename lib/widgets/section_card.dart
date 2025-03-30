import 'package:flutter/material.dart';
import '../models/game_state.dart';

class SectionCard extends StatelessWidget {
  final int sectionNumber;
  final bool isUnlocked;
  final FloorState floorState;
  final VoidCallback onTap;

  const SectionCard({
    super.key,
    required this.sectionNumber,
    required this.isUnlocked,
    required this.floorState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (floorState == FloorState.locked) {
      imagePath = 'assets/floors/locked_floor${sectionNumber}.png';
    } else {
      imagePath = isUnlocked
          ? 'assets/sections/floor${sectionNumber}/unlocked_section${sectionNumber}.png'
          : 'assets/sections/floor${sectionNumber}/locked_section${sectionNumber}.png';
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  floorState == FloorState.locked
                      ? 'Floor $sectionNumber'
                      : 'Section $sectionNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 