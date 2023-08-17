import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../util/manage_board.dart';
import '../global.dart';
import './manage_boardgame.dart';

class Background extends ParallaxComponent<BoardGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -5),
      velocityMultiplierDelta: Vector2(0, 1.2),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color(0xFF001C38));

    super.render(canvas);
    final customPainter = PaintBoard(
        Global.content,
        Global.size,
        Global.rectSize,
        size.x / 2 - Global.rectSize / 2,
        size.y / 2 - Global.rectSize / 2);
    customPainter.paint(canvas, Size(Global.rectSize, Global.rectSize));
  }
}
