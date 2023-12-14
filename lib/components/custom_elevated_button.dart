import 'package:flutter/material.dart';
import '/constants/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.tercharyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fixedSize: const Size(120, 30),
        minimumSize: const Size(120, 30),
      ),
      child: Text(
        title,
        style: MyFonts.firaSans(fontColor: MyColors.secondaryColor),
      ),
    );
  }
}
