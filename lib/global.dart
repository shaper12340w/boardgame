class Global {
  static double rectSize = 800;
  static double size = ((content.length - 4) / 4) + 2;
  static List<String> content = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p  "
  ];
  static List<List<int>> pitfall = [
    [3, 0]
  ]; // first element : target tile / second element : goto tile
  static List<int> color = [200, 200, 200];
  static int memberCount = 4;

  // variables
  static List<List<double>> positionMap = [];
  static List<int> memberPosition =
      List.generate(Global.memberCount, (index) => 0);
}
