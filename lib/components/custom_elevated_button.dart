import 'package:flutter/material.dart';
import '/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.width,
    required this.height,
  });
  final VoidCallback onPressed;
  final String title;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.secondaryColor.withOpacity(0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: MyColors.secondaryColor,
            width: 0.1,
          ),
        ),
        fixedSize: Size(width, height),
        minimumSize: Size(width, height),
      ),
      child: Text(
        title,
        style: MyFonts.bodyFont(
          fontColor: MyColors.secondaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
