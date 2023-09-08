import "../global.dart";
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/**
 * 넣을 기능들
 * 사탕 1개 획득
 * 토끼 머리띠 쓰고 게임하기!
 * 두칸 뒤로
 * 세칸 뒤로
 * 세칸 앞으로
 * 한칸 앞으로
 * 룰렛 (아니 판만 만들라메요;;; 선배시치;;)
 * 무인도...? ( 같은 주사위숫자가 연속으로 나오면 )
 * 한번더
 */

class MovePlayer {
  static int turnNum = 0;
  static List<bool> memberIsland =
      List.generate(Global.memberCount, (index) => false);

  static int _findElementIndex(List<int> list, int element, int? duplicate) {
    for (int i = 0; i < list.length; i++) {
      if (duplicate is int) {
        if (list[i] == element && i != duplicate) {
          return i;
        }
      } else if (list[i] == element) {
        return i; // 요소의 인덱스 반환
      }
    }
    return -1; // 요소를 찾지 못한 경우 -1 반환
  }

  static getDiceNumber() {
    final wsUrl = Uri.parse('ws://127.0.0.1:30001');
    var channel = WebSocketChannel.connect(wsUrl);

    return channel.stream;
  }

  static checkTurn(int diceNumber) {
    final nextPlayerNum = turnNum + 1 < Global.memberCount ? turnNum + 1 : 0;
    final nextPlayer = Global.memberDiceValue[nextPlayerNum];
    if (memberIsland[nextPlayerNum]) {
      memberIsland[nextPlayerNum] = false;
    }
    if (nextPlayer == diceNumber) {
      Global.memberDiceValue[nextPlayerNum] = 0;
      moveToIsland(nextPlayer);
    }
    turnNum = nextPlayerNum;
    MovePlayer.move(turnNum, diceNumber);
  }

  static moveToIsland(int playerNumber) {
    memberIsland[playerNumber] = true;
  }

  static void move(int player, int plus) {
    final duplicatedPlayer =
        _findElementIndex(Global.memberPosition, plus, player);
    if (duplicatedPlayer > 0) {
      Global.memberPosition[duplicatedPlayer] = 0;
    }
    Global.memberPosition[player] += plus;
  }
}
