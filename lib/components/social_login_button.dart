import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.assetIcon,
  });
  final String title;
  final IconData? icon;
  final String? assetIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 150,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MyColors.buttonColor1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetIcon != null) Image.asset(assetIcon!, height: 50),
            if (icon != null)
              Icon(icon, size: 30, color: MyColors.buttonColor1),
            const SizedBox(width: 20),
            Text(
              title,
              style: MyFonts.buttonFont(
                fontColor: MyColors.buttonColor1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
