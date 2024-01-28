import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    this.onChanged,
    required this.hintText,
  });

  final TextEditingController textController;
  final Function(String)? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      style: MyFonts.bodyFont(fontColor: MyColors.tercharyColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: MyFonts.bodyFont(
          fontColor: MyColors.tercharyColor.withOpacity(0.7),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: MyColors.secondaryColor,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
