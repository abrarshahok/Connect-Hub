import 'package:flutter/material.dart';
import '/constants/constants.dart';

AppBar customAppBar({
  bool? centerTitle,
  required String title,
  bool showLeadingButton = false,
  bool showActionButton = false,
  Widget? leadingButton,
  Widget? actionButton,
}) {
  return AppBar(
    backgroundColor: MyColors.primaryColor,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: MyFonts.logoFont(
        fontColor: MyColors.secondaryColor,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading:
        (showLeadingButton && leadingButton != null) ? leadingButton : null,
    actions: [
      if (showActionButton && actionButton != null) actionButton,
    ],
  );
}
