import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Function(String?)? onSaved;
  final TextEditingController? controller;
  final String? Function(String?) validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.onSaved,
    required this.validator,
    this.controller,
    this.obscureText = false,
  });
  OutlineInputBorder _getBorder(Color color) => OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: color,
          width: 0.5,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: key,
      color: MyColors.primaryColor,
      child: TextFormField(
        key: key,
        
        style: MyFonts.firaSans(
          fontColor: MyColors.secondaryColor,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          label: Text(
            label,
            style: MyFonts.firaSans(
              fontColor: MyColors.tercharyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          enabledBorder: _getBorder(MyColors.tercharyColor),
          focusedBorder: _getBorder(MyColors.secondaryColor),
          focusedErrorBorder: _getBorder(Colors.red),
          errorBorder: _getBorder(Colors.red),
        ),
        onSaved: onSaved,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        onTapOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
      ),
    );
  }
}
