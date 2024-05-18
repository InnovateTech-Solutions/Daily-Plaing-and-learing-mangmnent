import 'package:demogp/src/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextApp {
  static Text mainAppText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.subappcolor,
              fontWeight: FontWeight.bold,
              fontSize: 20)),
    );
  }

  static Text subAppText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: AppColor.buttonColor,
              fontWeight: FontWeight.w400,
              fontSize: 12)),
    );
  }
}
