import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_app_top_bar.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(title: 'Connect Hub'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            'No Internet Connection! Please check your internet connection and try again.',
            textAlign: TextAlign.center,
            style: MyFonts.headingFont(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
