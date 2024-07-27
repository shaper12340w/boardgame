import 'dart:math';

import 'package:boardgame/game/move_player.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';

import './util/color_schemes.dart';
import './util/check_platform.dart';

import './game/page.dart';
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

  void moveMember(BuildContext context) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("질문"), // Remove const here
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Success'), // Remove const here
                onPressed: () {
                  final todoAction = Global
                      .specialTile[Global.memberPosition[MovePlayer.turnNum]];
                  if (todoAction!.containsKey("success")) {
                    Global.memberPosition[MovePlayer.turnNum] =
                        todoAction["sucess"];
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Fail'), // Remove const here
                onPressed: () {
                  final todoAction = Global
                      .specialTile[Global.memberPosition[MovePlayer.turnNum]];
                  if (todoAction!.containsKey("fail")) {
                    Global.memberPosition[MovePlayer.turnNum] =
                        todoAction["fail"];
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final List<Widget> mainContents = [
      Center(
          child: GameWidget(
        game: game,
        overlayBuilderMap: {
          'gameOver': (context, game) => const Notice(),
        },
      )),
      StreamBuilder(
        stream: MovePlayer.getDiceNumber(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            MovePlayer.checkTurn(int.parse('$data'));
            print('$data');
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 에러 처리
            return Text('Error: ${snapshot.error}');
          } else {
            // 초기 로딩 상태 등을 처리할 수 있습니다.
            return const CircularProgressIndicator();
          }
        },
      )
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
          onPressed: () async {
            // Use setState to rebuild the widget with new values.
            final todoAction =
                Global.specialTile[Global.memberPosition[MovePlayer.turnNum]];
            if (todoAction is Map) {
              if (todoAction!.containsKey("execute")) {
                todoAction["execute"](MovePlayer.turnNum);
              }
              return _showMyDialog(todoAction['text']);
            }
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
