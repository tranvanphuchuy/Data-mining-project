import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class FloorSelectorButton extends StatefulWidget {
  const FloorSelectorButton({super.key});

  @override
  State<FloorSelectorButton> createState() => _FloorSelectorButtonState();
}

class _FloorSelectorButtonState extends State<FloorSelectorButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool isExpanded = false;
  Offset position = const Offset(0, 0);
  bool isDragging = false;
  Offset dragStartPosition = Offset.zero;
  Offset dragStartOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _startDragging(DragStartDetails details) {
    setState(() {
      isDragging = true;
      dragStartPosition = details.globalPosition;
      dragStartOffset = position;
    });
  }

  void _updateDragging(DragUpdateDetails details) {
    if (!isDragging) return;

    setState(() {
      final delta = details.globalPosition - dragStartPosition;
      position = dragStartOffset + delta;
      
      // Keep the button within screen bounds
      final size = MediaQuery.of(context).size;
      position = Offset(
        position.dx.clamp(0, size.width - 60),
        position.dy.clamp(0, size.height - 60),
      );
    });
  }

  void _endDragging(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: _startDragging,
        onPanUpdate: _updateDragging,
        onPanEnd: _endDragging,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isExpanded ? 200 : 60,
          height: isExpanded ? 300 : 60,
          decoration: BoxDecoration(
            color: const Color(0xFF461D7C),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Floor Options
              if (isExpanded)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isExpanded ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFloorOption(1, '1st Floor'),
                        _buildFloorOption(2, '2nd Floor'),
                        _buildFloorOption(3, '3rd Floor'),
                      ],
                    ),
                  ),
                ),
              // Toggle Button
              if (!isExpanded)
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: _toggleExpand,
                  ),
                )
              else
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _toggleExpand,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorOption(int floor, String label) {
    final gameState = context.watch<GameState>();
    final isUnlocked = floor == 1 || 
        (floor > 1 && gameState.getFloorState(floor - 1) == FloorState.unlocked);
    final isSelected = gameState.currentFloor == floor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked ? () {
            gameState.setCurrentFloor(floor);
            _toggleExpand();
          } : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFDD023) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF461D7C) : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (!isUnlocked)
                  const Icon(Icons.lock, color: Colors.white70, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 