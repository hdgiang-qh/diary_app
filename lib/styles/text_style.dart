import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_styles.dart';

class StyleApp {
  static TextStyle textStyle400({
    Color color = ColorAppStyle.black3D,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }
  static TextStyle textStyle401({
    Color color = ColorAppStyle.redFB,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }
  static TextStyle textStyle402({
    Color color = ColorAppStyle.blue00,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textStyle300({
    Color color = ColorAppStyle.black3D,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }
  static TextStyle textDate({
    Color color = ColorAppStyle.black3D,
    double fontSize = 12,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textStyle500({
    Color color = ColorAppStyle.black3D,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textStyle600({
    Color color = ColorAppStyle.black3D,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle textStyle700({
    Color color = ColorAppStyle.black3D,
    double fontSize = 14,
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      //fontFamily: fontFamily,
      decoration: TextDecoration.none,
    );
  }
}
