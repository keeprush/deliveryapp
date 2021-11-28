import 'package:flutter/material.dart';

import 'colors.dart';

class LoginBackground extends CustomPainter{

  // provider 을 위한 생성자를 만들어야한다.
  LoginBackground({required this.isJoin}); // class 생성자 (고객이 주문한 주문서)
  final bool isJoin;

  //26 38 75 1A264B
  //47 214 115 2FD673
  //237 226 64 EDE240
  //214 108 47 D66C2F
  //224 54 247 E036F7

  //207 185 151
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin ? color_red1 : on_color;
    //Paint paint = Paint()..color = isJoin ? Colors.red : const Color.fromRGBO(207, 185, 151, 1.0);
    // .. 때문에 = , = 이 가능하다.
    // Paint 오브젝트를 생성을 하여, 그 안에 있는 color 값을
    // Colors.blue 로 지정하여 paint에 넣어라!
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.01), size.height*0.55, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}
