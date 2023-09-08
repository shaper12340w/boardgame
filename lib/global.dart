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
    "p",
  ];
  static Map<int, int> pitfall = {
    3: 0
  }; // first element : target tile / second element : goto tile
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
