import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:collection/collection.dart';

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
  bool moving = false;
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

  Vector2 setPosition() {
    var mapData = Global.positionMap;
    if (mapData.isNotEmpty) {
      if (Global.memberPosition[playerNum - 1] == 0) {
        final smallRectSize = (Global.rectSize / Global.size) / 4;
        switch (playerNum) {
          case 1:
            return Vector2(
                mapData[0][0] - smallRectSize, mapData[0][1] - smallRectSize);
          case 2:
            return Vector2(
                mapData[0][0] + smallRectSize, mapData[0][1] - smallRectSize);
          case 3:
            return Vector2(
                mapData[0][0] - smallRectSize, mapData[0][1] + smallRectSize);
          case 4:
            return Vector2(
                mapData[0][0] + smallRectSize, mapData[0][1] + smallRectSize);
          default:
            throw Exception("not valid memberCount");
        }
      } else {
        return Vector2(mapData[Global.memberPosition[playerNum - 1]][0],
            mapData[Global.memberPosition[playerNum - 1]][1]);
      }
    } else {
      return pos;
    }
  }

  @override
  void update(double dt) {
    position = setPosition();
    super.update(dt);
    if (Global.positionMap.isEmpty) {
      return;
    }
    final playerIndex = playerNum - 1;
    final nowPosition = Global.positionMap[Global.memberPosition[playerIndex]];
    bool checkCondition(int index) =>
        Global.memberPosition[index] != 0 &&
        Global.memberPosition[index] !=
            Global.memberPosition.indexWhere((value) => value == 0) &&
        Global.memberPosition
            .where(
                (value) => value != 0 && value == Global.memberPosition[index])
            .isNotEmpty;
    if (!moving && !eq(nowPosition, [position.x, position.y])) {
      moving = true;
      if (checkCondition(playerNum - 1)) {
        //0을 제외하고 자신을 제외한 다른 플레이어가 있을때 => 겹칠때
      }
      // 자신이 0에 있을때 추가
    } else if (moving) {}
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
