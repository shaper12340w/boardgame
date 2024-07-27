import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import './move_player.dart';
import './manage_boardgame.dart';
import '../global.dart';

enum PlayerState { normal, cry, fun, angry }

Function eq = const ListEquality().equals;

class BoardGamePlayer extends SpriteGroupComponent<PlayerState>
    with HasGameRef<BoardGame>, CollisionCallbacks {
  BoardGamePlayer({
    required this.playerNum,
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );
  Vector2 pos = Vector2(100, 100);

  late int playerNum;
  bool isMoving = false;
  bool checkSet = false;
  List<int> pitfallList = [];
  int diceNumber = 0;
  int currentPosition = 0;
  Map<String, double> settings = {
    "velocity": 0,
    "acceleration": 0.1,
    "maxVelocity": 5
  };

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    await add(TextBoxComponent(
        text: Global.name[playerNum - 1],
        pixelRatio: 10,
        align: Anchor.centerLeft,
        position: Vector2(-50, 30)));

    await _loadCharacterSprites();

    setPosition();

    Global.pitfall.forEach((key, value) => pitfallList.add(key));

    current = PlayerState.normal;
  }

  int checkDuplicated() {
    //Global.memberPosition.firstWhere((number) => number == Global.memberPosition[playerNum - 1] && )
    int targetValue = Global.memberPosition[playerNum - 1];
    int foundIndex = -1;

    Map<int, int> numberMap = Global.memberPosition.asMap();
    numberMap.forEach((index, value) {
      if (value == targetValue &&
          index != (playerNum - 1) &&
          targetValue != 0) {
        foundIndex = index;
      }
    });
    return foundIndex; //duplicated된 member
  }

  void moveAnimation(int pos, {bool? move}) {
    void moveTo() {
      final changedPos = Global.positionMap[pos];
      final changedVector = Vector2(changedPos[0], changedPos[1]);
      final moveEffect = MoveEffect.to(changedVector, onComplete: () {
        current = PlayerState.normal;
        Global.memberPosition[playerNum - 1] = pos;
        currentPosition = Global.memberPosition[playerNum - 1];
        isMoving = false;
        _setPosition(changedVector);
      }, EffectController(duration: 1, curve: Curves.easeInOut));
      add(moveEffect);
    }

    isMoving = true;
    if (move is bool) {
      if (move) {
        final changedPos =
            Global.positionMap[Global.memberPosition[playerNum - 1]];
        final changedVector = Vector2(changedPos[0], changedPos[1]);
        final moveEffect = MoveEffect.to(changedVector, onComplete: () {
          current = PlayerState.cry;
          moveTo();
        }, EffectController(duration: 1, curve: Curves.easeInOut));
        add(moveEffect);
      }
    } else {
      moveTo();
    }
  }

  void _setPosition(Vector2 vector) {
    print("setPosition");
    position = vector;
    pos = vector;
  }

  void setPosition() {
    var mapData = Global.positionMap;
    if (mapData.isNotEmpty) {
      //Mapdata가 있을 경우
      if (Global.memberPosition[playerNum - 1] == 0 && !checkSet) {
        print("0 position set");
        //맵 위치가 0일경우
        final smallRectSize = (Global.rectSize / Global.size) / 4;
        switch (playerNum) {
          case 1:
            _setPosition(Vector2(
                mapData[0][0] - smallRectSize, mapData[0][1] - smallRectSize));
          case 2:
            _setPosition(Vector2(
                mapData[0][0] + smallRectSize, mapData[0][1] - smallRectSize));
          case 3:
            _setPosition(Vector2(
                mapData[0][0] - smallRectSize, mapData[0][1] + smallRectSize));
          case 4:
            _setPosition(Vector2(
                mapData[0][0] + smallRectSize, mapData[0][1] + smallRectSize));
          default:
            throw Exception("not valid memberCount");
        }
        checkSet = true;
      } else {
        // 위치가 0이 아닐 경우 포지션으로 설정
        if (!isMoving) {
          if (pitfallList.contains(Global.memberPosition[playerNum - 1])) {
            //함정
            final gotoNum = Global.pitfall[
                Global.memberPosition[playerNum - 1] % Global.content.length];
            moveAnimation(gotoNum!, move: true);
          } else if (MovePlayer.memberIsland[playerNum - 1]) {
            return;
          } else if (Global.memberPosition[playerNum - 1] != currentPosition) {
            final duplicatedMember = checkDuplicated();
            print(Global.memberPosition);
            if (duplicatedMember > -1) {
              Global.memberPosition[duplicatedMember] = 0;
            }
            if (Global.memberPosition[playerNum - 1] > Global.content.length) {
              Global.isWin = true;
            }
            //일반적으로 위치 바꼈을떄
            //외부에서 Global.memberPosition을 바꿨을때

            print(Global.memberPosition);
            moveAnimation(Global.memberPosition[playerNum - 1]);
          }
        }
      }
    } else {
      _setPosition(pos);
    }
  }

  @override
  void update(double dt) {
    setPosition();
    super.update(dt);
  }

  Future<void> _loadCharacterSprites() async {
    // Load & configure sprite assets
    final normal = await gameRef.loadSprite('cat.png');
    final cry = await gameRef.loadSprite('cat_crying.png');
    final fun = await gameRef.loadSprite('cat_sitting.png');
    final angry = await gameRef.loadSprite('cat_angry.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.normal: normal,
      PlayerState.cry: cry,
      PlayerState.fun: fun,
      PlayerState.angry: angry,
    };
  }
}
