import './game/move_player.dart';

class Global {
  static double rectSize = 800;
  static double size = ((content.length - 4) / 4) + 2;
  static List<String> content = [
    "START\n\nEND",
    "룰렛",
    "한칸 앞으로",
    "Yes or No",
    "고백하기\n(싫으면 2칸 뒤로)",
    "참참참 앞으로",
    "랜덤 위치 바꾸기",
    "토끼 머리띠",
    "한번 더",
    "세칸 뒤로",
    "무인도로",
    "진행시켜",
    "눈치게임\n(지면 2칸 뒤로)",
    "두칸 뒤로",
    "처음으로",
    "애교하기",
  ];
  static Map<int, int> pitfall = {
    2: 3,
    9: 6,
    13: 11,
    14: 0
  }; // first element : target tile / second element : goto tile
  static String nowString = '';

  static bool isWin = false;

  static List<String> name = ["플레이어 1", "플레이어 2", "플레이어 3", "플레이어 4"];

  static Map<int, Map<String, dynamic>> specialTile = {
    3: {"text": ""},
    4: {"text": "고백하기\n(사실 난 ~~적 있다)", "fail": 2},
    5: {"text": "참참참", "sucess": 6},
    6: {"execute": MovePlayer.moveToIsland},
    7: {"text": "영차"},
    8: {"text": "눈치게임", "fail": 6},
    11: {"text": ""}
  };
  static Map<String, String> colorList = {
    "tile": "#C8C8C8",
    "background": "#5F5F5F",
    "pitfall": "#F8FFB5"
  };
  static int memberCount = 4;
  static const double fontSize = 15;
  // variables
  static List<List<double>> positionMap = [];
  static List<double> islandPosition = [];
  static List<int> memberDiceValue =
      List.generate(Global.memberCount, (index) => 0);
  static List<int> memberPosition =
      List.generate(Global.memberCount, (index) => 0);
}
