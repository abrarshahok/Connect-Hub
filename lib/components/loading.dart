import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.buttonColor1,
      ),
    );
  }
}
