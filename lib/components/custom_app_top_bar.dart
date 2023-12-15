import 'dart:ui';
import 'package:flutter/material.dart';
import '/constants/constants.dart';

class CustomAppTopBar extends StatelessWidget {
  const CustomAppTopBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.showActionButton = false,
    this.showLeadingButton = false,
    this.actionButton,
    this.leadingButton,
  });
  final String title;
  final bool centerTitle;
  final bool showActionButton;
  final bool showLeadingButton;
  final Widget? actionButton;
  final Widget? leadingButton;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: MyColors.secondaryColor,
              width: 0.1,
            ),
          ),
          child: Row(
            children: [
              if (showLeadingButton) leadingButton!,
              Text(
                title,
                style: MyFonts.logoFont(
                  fontColor: MyColors.secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (showActionButton) actionButton!,
            ],
          ),
        ),
      ),
    );
  }
}
