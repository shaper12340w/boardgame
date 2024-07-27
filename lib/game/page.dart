import 'package:flutter/material.dart';
import '../global.dart';

class Notice extends StatelessWidget {
  const Notice({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Container(
        // 배경 색상을 설정하고 반투명도 조절
        color: Color.fromARGB(52, 95, 92, 92), // RGBA 색상 (빨간색, 50% 투명)
        child: const Center(
          child: Text(
            "Game over",
            style: TextStyle(
              fontSize: 36,
              color: Colors.white, // 글자 색상
            ),
          ),
        ),
      ),
    ));
  }
}
