class Global {
  static double rectSize = 800;
  static double size = ((content.length - 4) / 4) + 2;
  static List<String> content = [
    "안녕",
    "하세요",
    "저는",
    "사람",
    "입니다",
    "ㅋㅋ",
    "와",
    "센즈",
    "아시는구나",
    "겁나",
    "어렵습니다",
    "ㄹㅇ",
    "ㅋㅋ",
    "이거",
    "치는게",
    "더힘듦ㄹㅇ",
    "안녕",
    "하세요",
    "저는",
    "사람",
    "입니다",
    "ㅋㅋ",
    "와",
    "센즈",
    "아시는구나",
    "겁나",
    "어렵습니다",
    "ㄹㅇ",
    "ㅋㅋ",
    "이거",
    "치는게",
    "더힘듦ㄹㅇ",
  ];
  static List<List<int>> pitfall = [
    [3, 0]
  ]; // first element : target tile / second element : goto tile
  static List<int> color = [200, 200, 200];
  static int memberCount = 4;
  static const double fontSize = 10;
  // variables
  static List<List<double>> positionMap = [];
  static List<int> memberPosition =
      List.generate(Global.memberCount, (index) => 0);
}
