import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';

import './util/color_schemes.dart';
import './util/check_platform.dart';

import './game/manage_boardgame.dart';
import './global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CheckPlatform.sizeWindowByPlatforms();
  runApp(const BoardGameBoard());
}

class BoardGameBoard extends StatefulWidget {
  //constructor
  const BoardGameBoard({super.key});

  @override
  State<BoardGameBoard> createState() => BoardGameBoardState();
}

class BoardGameBoardState extends State<BoardGameBoard> {
  //previous settings
  int moveUser = Random().nextInt(Global.memberCount);
  String haveToMove = "right";
  final double moveSize = Global.rectSize / Global.size;
  final Map userPosition = {};
  final BoardGame game = BoardGame();

  BorderRadiusGeometry radius = BorderRadius.circular(8);

  void gameWin(String member) {}

  void moveMember() {
    setState(() {
      Global.memberPosition[0]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> mainContents = [
      Center(child: GameWidget(game: game)),
      Center(
          child:
              ElevatedButton(onPressed: moveMember, child: const Text("테스트용"))),
    ];

    return MaterialApp(
      title: "BoardGame",
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BoardGame"),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: mainContents,
        ),
        floatingActionButton: FloatingActionButton(
          // When the user taps the button
          onPressed: () {
            // Use setState to rebuild the widget with new values.
            setState(() {
              // Create a random number generator.
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
