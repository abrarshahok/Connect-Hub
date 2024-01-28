import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ShowSnackBar {
  final BuildContext context;
  final String label;
  final Color color;
  const ShowSnackBar({
    required this.context,
    required this.label,
    required this.color,
  });
  void show() {
    final currentContext = ScaffoldMessenger.of(context);
    if (currentContext.mounted) {
      currentContext.removeCurrentSnackBar();
    }
    currentContext.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        content: Text(
          label,
          style: MyFonts.bodyFont(
            fontColor: MyColors.primaryColor,
            fontSize: 15,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
