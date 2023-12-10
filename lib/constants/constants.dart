import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyIcons {
  static const String instagramIcon = 'assets/icon/instagram.png';
  static const String instagramLogo = 'assets/images/instagram_logo.png';
  static const String defaultProfilePicUrl =
      "https://firebasestorage.googleapis.com/v0/b/instagram-clone-21bscs20.appspot.com/o/user_posts%2Fdefault.jpg?alt=media&token=11d99af4-a9a2-48ef-bab9-29c5bf3485ed";
}

class MyColors {
  static Color primaryColor = Colors.grey[900]!;
  static Color secondaryColor = Colors.white;
  static Color tercharyColor = Colors.grey[600]!;
  static Color buttonColor1 = Colors.blue.shade700;
  static Color buttonColor2 = Colors.blue.shade500;
}

class MyFonts {
  static TextStyle firaSans({
    FontWeight? fontWeight,
    Color? fontColor,
    double? fontSize,
  }) =>
      GoogleFonts.firaSans(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      );
}
