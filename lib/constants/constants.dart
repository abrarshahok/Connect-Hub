import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/custom_page_transition_builder.dart';

class MyImages {
  static const String defaultProfilePicUrl =
      "https://firebasestorage.googleapis.com/v0/b/connect-hub-40e51.appspot.com/o/user_profile_pictures%2Fdefault.png?alt=media&token=02e0efea-5488-4204-a3b3-9811c6225eb9";
  static const String startupImage = 'assets/images/start.jpg';
  static const String googleImage = 'assets/images/google.png';
}

class MyColors {
  static Color primaryColor = Colors.white;
  static Color secondaryColor = Colors.grey[900]!;
  static Color tercharyColor = const Color(0xFF4A4A4A);
  static Color buttonColor1 = Colors.deepPurple;
  static Color onlineColor = Colors.green;
  static Color buttonColor2 = Colors.deepPurpleAccent;
}

class MyFonts {
  static TextStyle bodyFont({
    FontWeight? fontWeight,
    Color? fontColor,
    double? fontSize,
  }) =>
      GoogleFonts.openSans(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      );

  static TextStyle headingFont({
    FontWeight? fontWeight,
    Color? fontColor,
    double? fontSize,
  }) =>
      GoogleFonts.montserrat(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      );

  static TextStyle buttonFont({
    FontWeight? fontWeight,
    Color? fontColor,
    double? fontSize,
  }) =>
      GoogleFonts.poppins(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      );
  static TextStyle logoFont({
    FontWeight? fontWeight,
    Color? fontColor,
    double? fontSize,
  }) =>
      GoogleFonts.averiaSansLibre(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      );
}

final customPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CustomPageTransitionBuilder(),
    TargetPlatform.iOS: CustomPageTransitionBuilder(),
  },
);
