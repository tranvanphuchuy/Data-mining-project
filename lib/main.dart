import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/game_state.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'LSU PFT Scavenger Hunt',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF461D7C), // LSU Purple
            primary: const Color(0xFF461D7C),
            secondary: const Color(0xFFFDD023), // LSU Gold
          ),
          textTheme: GoogleFonts.robotoTextTheme(),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
