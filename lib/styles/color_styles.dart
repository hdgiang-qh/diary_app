import 'dart:math';

import 'package:flutter/material.dart';

class ColorAppStyle {
  static const Color black1A = Color(0xff5e5873);
  static const Color black3D = Color(0xff3D4043);
  static const Color black7D = Color(0xff7d7aa0);
  static const Color black2C = Color(0xff2C2C2C);
  static const Color black5E = Color(0xff5e5873);
  static const Color green1D = Color(0xff1dc555);
  static const Color green28 = Color(0xff28c76f);
  static const Color greenE5 = Color(0xffe5f8ed);
  static const Color greyF2 = Color(0xfff2f3f3);
  static const Color greyF3 = Color(0xfff3f2f7);
  static const Color greyD8 = Color(0xffd8d6de);
  static const Color blackDA = Color(0xffDADCE0);
  static const Color blue9F = Color(0xff9FC5E8);
  static const Color blue0B = Color(0xff0b24fa);
  static const Color blueMid = Color(0xff191970);
  static const Color blue00 = Color(0xff00cfe8);
  static const Color blueE0 = Color(0xffe0f9fc);
  static const Color redFB = Color(0xfffb101b);
  static const Color redEA = Color(0xffea5455);
  static const Color redFC = Color(0xfffceaea);
  static const Color redFF = Color(0xfffff3e8);
  static const Color yellowFE = Color(0xfffed531);
  static const Color yellowFF = Color(0xffff9f43);
  static const Color yellowD2 = Color(0xffd2af6c);
  static const Color whiteFA = Color(0xfffaf5ed);
  static const Color white = Color(0xffffffff);
  static const Color brownD2 = Color(0xffd2af6c);
  static const Color purple6f = Color(0xff6f5f90);
  static const Color purple8a = Color(0xff8a5082);
  static const Color blue75 = Color(0xff758eb7);
  static const Color app1 = Color(0xffe27d60);
  static const Color app2 = Color(0xff00CED1);
  static const Color app3 = Color(0xffe8a87c);
  static const Color app4 = Color(0xffc38d9e);
  static const Color app5 = Color(0xff659dbd);
  static const Color app6 = Color(0xfffbeec1);
  static const Color app7 = Color(0xff8d8741);
  static const Color app8 = Color(0xff8ee4af);
  static const Color button = Color(0xff41b3a3);

  static List<Color> colorList = [
    redFB,yellowFE,blueMid,green1D,greyF2,app1,purple6f,Colors.orange
  ];

  static Color getRandomColor() {
    Random random = Random();
    return colorList[random.nextInt(colorList.length)];
  }
}

const Color primaryColor = Color(0xff0089d1);
