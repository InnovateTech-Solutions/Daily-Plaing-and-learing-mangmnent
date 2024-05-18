import 'dart:ui';

import 'package:flutter_svg/svg.dart';

class ProfileButton {
  late SvgPicture icon;
  late String title;
  late VoidCallback onTap;

  ProfileButton({required this.title, required this.icon, required this.onTap});
}
