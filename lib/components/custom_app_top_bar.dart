import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '/constants/constants.dart';
import 'custom_icon_button.dart';

AppBar customAppBar({
  bool? centerTitle,
  required String title,
  bool showLeadingButton = false,
  bool showActionButton = false,
  Widget? actionButton,
  BuildContext? context,
}) {
  return AppBar(
    backgroundColor: MyColors.primaryColor,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: MyFonts.headingFont(
        fontColor: MyColors.secondaryColor,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: (showLeadingButton && context != null)
        ? CustomIconButton(
            icon: IconlyLight.arrow_left,
            color: MyColors.tercharyColor,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
    actions: [
      if (showActionButton && actionButton != null) actionButton,
    ],
  );
}
