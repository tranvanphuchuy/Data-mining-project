import 'package:flutter/material.dart';
import '../models/game_state.dart';

class SectionCard extends StatelessWidget {
  final int sectionNumber;
  final bool isUnlocked;
  final VoidCallback onTap;
  final FloorState floorState;

  const SectionCard({
    super.key,
    required this.sectionNumber,
    required this.isUnlocked,
    required this.onTap,
    required this.floorState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: floorState == FloorState.locked
              ? onTap
              : (isUnlocked ? onTap : null),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(
                  floorState == FloorState.locked
                      ? 'assets/images/floors/locked_floor.png'
                      : isUnlocked
                          ? 'assets/images/sections/floor1/unlocked_section$sectionNumber.png'
                          : 'assets/images/sections/floor1/locked_section$sectionNumber.png',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  floorState == FloorState.locked
                      ? Colors.transparent
                      : (isUnlocked ? Colors.transparent : Colors.grey.withOpacity(0.5)),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          floorState == FloorState.locked
                              ? 'Floor'
                              : 'Section $sectionNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (floorState != FloorState.locked)
                          Icon(
                            isUnlocked ? Icons.lock_open : Icons.lock,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 