import 'dart:ui';
import 'package:flutter/material.dart';
import '/constants/constants.dart';

class CustomAppTopBar extends StatelessWidget {
  const CustomAppTopBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.showActionButton = false,
    this.actionButton,
  });
  final String title;
  final bool centerTitle;
  final bool showActionButton;
  final Widget? actionButton;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: MyFonts.firaSans(
                  fontColor: MyColors.secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showActionButton) actionButton!,
            ],
          ),
        ),
      ),
    );
  }
}
