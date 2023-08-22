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
      ..color = const Color.fromARGB(137, 95, 95, 95)
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
      final smallRect = Rect.fromCenter(
          center: Offset(pX + defaultX, pY + defaultY),
          width: rectWidth - 10,
          height: rectHeight - 10);
      final paintSmall = Paint()
        ..color =
            Color.fromRGBO(Global.color[0], Global.color[1], Global.color[2], 1)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
          RRect.fromRectAndRadius(smallRect, const Radius.circular(15)),
          paintSmall);

      final textPainter = TextPainter(
          text: TextSpan(
            text: content[index],
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
      Global.positionMap.add([pX + defaultX, pY + defaultY]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
