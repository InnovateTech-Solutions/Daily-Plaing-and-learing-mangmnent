import 'package:demogp/src/config/theme/theme.dart';
import 'package:demogp/src/featuers/profile/model/profile_button_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

profileContainer(ProfileButton profile) {
  return InkWell(
    onTap: profile.onTap,
    child: Row(
      children: [
        const Gap(10),
        textFieldLabel(profile.title),
        const Spacer(),
        profile.icon,
      ],
    ),
  );
}

textFieldLabel(String title) {
  return Text(title,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.buttonColor)));
}
