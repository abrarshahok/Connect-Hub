import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Function(String?)? onSaved;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.onSaved,
    required this.validator,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });
  OutlineInputBorder _getBorder(Color color) => OutlineInputBorder(
        gapPadding: 5,
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: key,
      color: MyColors.primaryColor,
      child: TextFormField(
        key: key,
        style: MyFonts.bodyFont(
          fontColor: MyColors.secondaryColor,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          label: Text(
            label,
            style: MyFonts.bodyFont(
              fontColor: MyColors.tercharyColor.withOpacity(0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          suffixIcon: suffixIcon,
          enabledBorder: _getBorder(MyColors.buttonColor1.withOpacity(0.3)),
          focusedBorder: _getBorder(MyColors.buttonColor1),
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
