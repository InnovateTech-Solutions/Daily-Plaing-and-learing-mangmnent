import 'package:demogp/src/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttons {
  static selectedButton(String text, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 146,
        height: 46,
        decoration: BoxDecoration(
            color: AppColor.subappcolor,
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontSize: 15,
              color: AppColor.mainAppColor,
            )),
          ),
        ),
      ),
    );
  }
}
