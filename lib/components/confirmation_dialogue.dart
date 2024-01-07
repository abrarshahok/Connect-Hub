import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ConfirmationDialogue {
  final BuildContext context;
  final String message;
  final VoidCallback onTapYes;

  ConfirmationDialogue({
    required this.context,
    required this.message,
    required this.onTapYes,
  });

  show() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentTextStyle:
            MyFonts.bodyFont(fontColor: MyColors.secondaryColor, fontSize: 12),
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'Are you sure?',
          style: MyFonts.bodyFont(
              fontColor: MyColors.secondaryColor, fontSize: 16),
        ),
        content: Text(
          message,
          style: MyFonts.bodyFont(
              fontColor: MyColors.secondaryColor, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'No',
              style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: onTapYes,
            child: Text(
              'Yes',
              style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
