import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import './manage_boardgame.dart';
import '../global.dart';

enum PlayerState { normal, cry, fun, angry }

Function eq = const ListEquality().equals;

class BoardGamePlayer extends SpriteGroupComponent<PlayerState>
    with HasGameRef<BoardGame>, KeyboardHandler, CollisionCallbacks {
  BoardGamePlayer({
    required this.playerNum,
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );
  Vector2 pos = Vector2(100, 100);

  late int playerNum;
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

    await _loadCharacterSprites();

    setPosition();

    current = PlayerState.normal;
  }

  bool checkCondition(int index) =>
      Global.memberPosition[index] != 0 &&
      Global.memberPosition[index] !=
          Global.memberPosition.indexWhere((value) => value == 0) &&
      Global.memberPosition
          .where((value) => value != 0 && value == Global.memberPosition[index])
          .isNotEmpty;

  void _setPosition(Vector2 vector) {
    position = vector;
    pos = vector;
  }

  void setPosition() {
    var mapData = Global.positionMap;
    if (mapData.isNotEmpty) {
      //Mapdata가 있을 경우
      if (Global.memberPosition[playerNum - 1] == 0) {
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
      } else {
        // 위치가 0이 아닐 경우 포지션으로 설정
        /**
          return Vector2(mapData[Global.memberPosition[playerNum - 1]][0],
            mapData[Global.memberPosition[playerNum - 1]][1]);
         */
        if (Global.memberPosition[playerNum - 1] != currentPosition) {
          currentPosition = Global.memberPosition[playerNum - 1];
          final changedPos = mapData[Global.memberPosition[playerNum - 1]];
          final changedVector = Vector2(changedPos[0], changedPos[1]);
          final moveEffect = MoveEffect.to(changedVector, onComplete: () {
            _setPosition(changedVector);
          }, EffectController(duration: 1, curve: Curves.easeInOut));
          add(moveEffect);
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
