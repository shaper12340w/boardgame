import 'package:boardgame/global.dart';
import 'package:flame/game.dart';

import './manage_player.dart';
import './manage_backgroud.dart';

class BoardGame extends FlameGame {
  BoardGame({super.children});
  late final RouterComponent router;
  final Background background = Background();
  List<BoardGamePlayer> playerList = [];
  bool isDisplayed = false;

  @override
  Future<void> onLoad() async {
    for (int index = 1; index <= Global.memberCount; index++) {
      final BoardGamePlayer player = BoardGamePlayer(playerNum: index);
      player.width = 50;
      player.height = 50;
      await add(player);
      playerList.add(player);
    }
    await add(background);
  }

  @override
  void update(double dt) {
    if (!isDisplayed && Global.isWin) {
      overlays.add("gameOver");
      isDisplayed = !isDisplayed;
    }
    super.update(dt);
  }
}
