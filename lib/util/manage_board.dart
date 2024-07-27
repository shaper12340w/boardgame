import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global.dart';

class PaintBoard extends CustomPainter {
  final List<String> content;
  final double listSize; // 리스트 길이
  final double rectSize; //정사각형 크기
  final double defaultX;
  final double defaultY;

  PaintBoard(
      this.content, this.listSize, this.rectSize, this.defaultX, this.defaultY);
  Color hexToColor(String hexColor) {
    // Remove '#' symbol if present
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }

    // Parse hex color string to integer value
    final int hexValue = int.parse(hexColor, radix: 16);

    // Create a Color object from the integer value
    return Color(hexValue | 0xFF000000); // Adding alpha value FF (opaque)
  }

  void drawSmallRect(Canvas canvas, double rectWidth, double rectHeight,
      double pX, double pY, int? index) {
    final smallRect = Rect.fromCenter(
        center: Offset(pX + defaultX, pY + defaultY),
        width: rectWidth - 10,
        height: rectHeight - 10);
    final paintSmall = Paint()
      ..color = hexToColor(Global.pitfall.keys.toList().contains(index)
          ? Global.colorList['pitfall']!
          : Global.colorList["tile"]!)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(smallRect, const Radius.circular(15)),
        paintSmall);

    final textPainter = TextPainter(
        text: TextSpan(
          text: index is int ? content[index] : "무인도",
          style: GoogleFonts.audiowide(
              textStyle: const TextStyle(
                  fontSize: Global.fontSize, color: Colors.black87)),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(pX - textPainter.width / 2 + defaultX,
            pY - textPainter.height / 2 + defaultY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (listSize.toInt().toDouble() != listSize) {
      throw Exception("Not valid list count.\nMust it can be divided in 4");
    }
    if (content.length < 8) {
      throw Exception("Option value is too small");
    }
    final bigRect = Rect.fromPoints(Offset(defaultX, defaultY),
        Offset(defaultX + rectSize, defaultY + rectSize));
    final paint = Paint()
      ..color = hexToColor(Global.colorList["background"]!)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(bigRect, const Radius.circular(15)), paint);

    int bigIndex = 0;
    double placeX = 0;
    double placeY = 0;
    double rectWidth = rectSize / listSize;
    double rectHeight = rectSize / listSize;

    for (int index = 0; index < content.length; index++) {
      if (index + 1 == listSize ? true : index % (listSize - 1) == 0) {
        bigIndex++;
      }
      switch (bigIndex) {
        case 1:
          placeX = rectWidth * index;
          placeY = 0;
          break;
        case 2:
          placeX = rectWidth * (listSize - 1);
          placeY = rectHeight * (index - (listSize - 1) * (bigIndex - 1));
          break;
        case 3:
          placeX = rectWidth * ((listSize - 1) * bigIndex - index);
          placeY = rectHeight * (listSize - 1); // 왼쪽 아래
          break;
        case 4:
          placeX = 0;
          placeY = rectHeight * ((listSize - 1) * bigIndex - index);
          break;
      }
      final pX = rectWidth / 2 + placeX;
      final pY = rectHeight / 2 + placeY;
      drawSmallRect(canvas, rectWidth, rectHeight, pX, pY, index);
      Global.positionMap.add([pX + defaultX, pY + defaultY]);
    }
    //무인도 그리기
    drawSmallRect(
        canvas, rectWidth, rectHeight, rectSize / 2, rectSize / 2, null);
    Global.islandPosition = [rectSize / 2 + defaultX, rectSize / 2 + defaultY];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
